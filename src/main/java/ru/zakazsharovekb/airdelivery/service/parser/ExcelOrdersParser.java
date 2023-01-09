package ru.zakazsharovekb.airdelivery.service.parser;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import ru.zakazsharovekb.airdelivery.common.enums.OrderStatus;
import ru.zakazsharovekb.airdelivery.common.enums.TransferType;
import ru.zakazsharovekb.airdelivery.model.DeliveryTime;
import ru.zakazsharovekb.airdelivery.model.Order;

import java.io.IOException;
import java.io.InputStream;
import java.time.*;
import java.util.ArrayList;
import java.util.List;

public class ExcelOrdersParser {
    public ExcelOrdersParser() {
    }

    public List<Order> parseOrdersFromXlsx() throws IOException {

        InputStream inputStream = null;
        inputStream = YandexDiskDownload.getFilefromYandexDisk();
        Workbook workbook = new XSSFWorkbook(inputStream);
        List<Order> orders = new ArrayList<>();
//        Sheet sheet = workbook.getSheet("Январь 2023");
        for (Sheet sheet : workbook) {
            for (Row row : sheet) {
                if (row.getCell(1) != null && isRowNotEmpty(row)) {
                    Order order = extractOrderFromRow(row);
                    System.out.println("New Order: " + order.getDelivery().getDeliveryTime().getStartTime() + " - " + order.getDelivery().getDeliveryTime().getEndTime().toLocalDate());
                    orders.add(order);
                }
            }
        }

        return orders;
    }

    private boolean isRowNotEmpty(Row row) {
        return !extractStringFromCell(row.getCell(1)).isBlank()
                && (
                !row.getCell(2).getStringCellValue().isBlank()
                        || !row.getCell(3).getStringCellValue().isBlank()
                        || row.getCell(4).getNumericCellValue() != 0
                        || !row.getCell(5).getStringCellValue().isBlank()
                        || !row.getCell(6).getStringCellValue().isBlank()
        );
    }

    private Order extractOrderFromRow(Row row) {
        Order order = new Order();
        DataFormatter dataFormatter = new DataFormatter();
        order.setOrderComment(dataFormatter.formatCellValue(row.getCell(6)) + ", " + dataFormatter.formatCellValue(row.getCell(0)));
        order.getDelivery().setDeliveryTime(parseStartAndEndTimeFromCells(row.getCell(1), row.getCell(2)));
        order.setSum((row.getCell(4) == null ? 0 : extractDoubleFromCell(row.getCell(4))));
        order.getDelivery().setAddress((dataFormatter.formatCellValue(row.getCell(3))));
        order.getCustomer().setPhone(formatPhone(dataFormatter.formatCellValue(row.getCell(5))));
        order.setTransferType(parseTransferType(row.getCell(3)));
        order.setStatus(OrderStatus.DELIVERED);
        order.getDelivery().setComment(row.getCell(6) == null ? "" : dataFormatter.formatCellValue(row.getCell(6)));
        System.out.println(order.getDelivery().getAddress() + " " + order.getCustomer().getPhone());
        return order;
    }

    private String formatPhone(String number) {
        String onlyDigitsNumber = number.replaceAll("\\D", "").trim();
        if (onlyDigitsNumber.length() >= 10) {
            return "+7" + onlyDigitsNumber.substring(onlyDigitsNumber.length() - 10);
        } else return onlyDigitsNumber;
    }

    private Double extractDoubleFromCell(Cell cell) {
        return switch (cell.getCellType()) {
            case STRING -> Double.parseDouble(cell.getStringCellValue().isBlank() ? "0" : cell.getStringCellValue());
            case NUMERIC -> cell.getNumericCellValue();
            default -> 0.0;
        };
    }

    private String extractStringFromCell(Cell cell) {
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> Double.toString(cell.getNumericCellValue());
            default -> "";
        };
    }

    private TransferType parseTransferType(Cell addressCell) {
        String cellValue = addressCell.getStringCellValue().toLowerCase().trim();
        if (cellValue.contains("самовыв") || cellValue.isBlank()) {
            return TransferType.PICKUP;
        } else return TransferType.DELIVERY;
    }


    public DeliveryTime parseStartAndEndTimeFromCells(Cell dateCell, Cell timeCell) {
        String timeCellValue = timeCell.getStringCellValue().toLowerCase().trim();
        String before = "до";
        String after = "после";
        String since = "с";
        DeliveryTime deliveryTime = new DeliveryTime();
        LocalDate date = Instant.ofEpochMilli(dateCell.getDateCellValue().getTime()).atZone(ZoneId.systemDefault()).toLocalDate();

        if (timeCellValue.matches(before + ".*\\d+.*")) {
            LocalTime endTime = extractHoursAndMinutes(timeCellValue, before);
            deliveryTime.setStartTime(LocalDateTime.of(date, LocalTime.MIN));
            deliveryTime.setEndTime(LocalDateTime.of(date, endTime));
            return deliveryTime;
        }

        if (timeCellValue.matches(after + ".*\\d+.*")) {
            LocalTime startTime = extractHoursAndMinutes(timeCellValue, after);
            deliveryTime.setStartTime(LocalDateTime.of(date, startTime));
            deliveryTime.setEndTime(LocalDateTime.of(date, LocalTime.MAX));
            return deliveryTime;
        }

        if (timeCellValue.matches(".*\\d+.*" + before + ".*\\d+.*")) {
            String[] twoValues = timeCellValue.split("до");
            if (twoValues.length == 2) {
                extractFromTwoValues(deliveryTime, date, twoValues);
            }
            return deliveryTime;
        }

        if (timeCellValue.matches(since + ".*\\d+.*")) {
            LocalTime startTime = extractHoursAndMinutes(timeCellValue, since);
            deliveryTime.setStartTime(LocalDateTime.of(date, startTime));
            deliveryTime.setEndTime(LocalDateTime.of(date, LocalTime.MAX));
            return deliveryTime;
        }

        if (timeCellValue.matches("\\d{1,2}(\\D|-)\\d{1,2}\\D?.*")) {
            String[] twoValues = timeCellValue.split("-");
            if (twoValues.length == 2) {
                extractFromTwoValues(deliveryTime, date, twoValues);
            } else {
                String startAndEndTimeString = twoValues[0].trim();
                LocalTime startAndEndTime = extractHoursAndMinutes(startAndEndTimeString, "");
                LocalDateTime startAndEndDateTime = LocalDateTime.of(date, startAndEndTime);
                deliveryTime.setStartTime(startAndEndDateTime);
                deliveryTime.setEndTime(startAndEndDateTime);
            }
            return deliveryTime;
        }

        if (timeCellValue.replaceAll("[А-Яа-яA-Za-z]", "").trim().isBlank() || (deliveryTime.getStartTime() == null && deliveryTime.getEndTime() == null)) {
            deliveryTime.setStartTime(LocalDateTime.of(date, LocalTime.MIN));
            deliveryTime.setEndTime(LocalDateTime.of(date, LocalTime.MAX));
        }
        return deliveryTime;
    }

    private void extractFromTwoValues(DeliveryTime deliveryTime, LocalDate date, String[] twoValues) {
        String startTimeString = twoValues[0].trim();
        String endTimeString = twoValues[1].trim();
        LocalTime startTime = extractHoursAndMinutes(startTimeString, "");
        LocalTime endTime = extractHoursAndMinutes(endTimeString, "");
        deliveryTime.setStartTime(LocalDateTime.of(date, startTime));
        deliveryTime.setEndTime(LocalDateTime.of(date, endTime));
    }

    private LocalTime extractHoursAndMinutes(String cellString, String prefix) {
        String stringForSplit = cellString.replace(prefix, "").replaceAll("[А-Яа-яA-Za-z]", "").trim();
        String[] splittedStringArray = stringForSplit.split("[:\\s\\-.,/]");
        String hours;
        String minutes = "00";
        LocalTime hoursAndMinutes;

        if (splittedStringArray.length >= 1) {
            hours = splittedStringArray[0].replaceAll("\\D", "");
            if (hours.isBlank() || hours.length() > 2) {
                throw new IllegalArgumentException("Hours not parsed");
            }
        } else throw new IllegalArgumentException("Hours not parsed");

        if (splittedStringArray.length >= 2) {
            minutes = splittedStringArray[1].replaceAll("\\D", "");
            if (minutes.isBlank() || minutes.length() > 2) {
                minutes = "00";
            }
        }

        if (hours.equals("24") && minutes.equals("00")) {
            return LocalTime.of(23, 59);
        }

        hoursAndMinutes = LocalTime.of(Integer.parseInt(hours), Integer.parseInt(minutes));
        return hoursAndMinutes;
    }
}