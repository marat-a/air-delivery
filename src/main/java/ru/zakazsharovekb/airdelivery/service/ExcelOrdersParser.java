package ru.zakazsharovekb.airdelivery.service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import ru.zakazsharovekb.airdelivery.common.enums.TransferType;
import ru.zakazsharovekb.airdelivery.model.DeliveryTime;
import ru.zakazsharovekb.airdelivery.model.Order;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URL;
import java.time.*;
import java.util.ArrayList;
import java.util.List;

public class ExcelOrdersParser {
    public ExcelOrdersParser() {
    }

    public List<Order> parseOrdersFromXlsx(String uri) throws IOException {
        FileInputStream file = new FileInputStream(getFileFromResourcesFolder(uri));
        Workbook workbook = new XSSFWorkbook(file);
        Sheet sheet = workbook.getSheetAt(14);
        List<Order> orders = new ArrayList<>();
        for (Row row : sheet) {
            if ( (row.getCell(1).getDateCellValue() != null)&&isRowNotEmpty(row)) {
                System.out.println("New Order");
                Order order = extractOrderFromRow(row);
                orders.add(order);
            }
        }
        return orders;
    }

    private boolean isRowNotEmpty (Row row){
        return !row.getCell(2).getStringCellValue().isBlank()
                ||!row.getCell(3).getStringCellValue().isBlank()
                ||!row.getCell(4).getStringCellValue().isBlank()
                ||!row.getCell(5).getStringCellValue().isBlank()
                ||!row.getCell(6).getStringCellValue().isBlank();
    }

    private File getFileFromResourcesFolder(String fileName) {
        ClassLoader classLoader = ExcelOrdersParser.class.getClassLoader();
        URL resource = classLoader.getResource(fileName);
        if (resource == null) {
            throw new IllegalArgumentException("File not found!");
        } else return new File(resource.getFile());
    }

    private Order extractOrderFromRow(Row row) {
        Order order = new Order();
        DataFormatter dataFormatter = new DataFormatter();
        order.setOrderComment(dataFormatter.formatCellValue(row.getCell(6)) + ", " + dataFormatter.formatCellValue(row.getCell(0)));
        order.getDelivery().setDeliveryTime(parseStartAndEndTimeFromCells(row.getCell(1), row.getCell(2)));
        order.setSum((row.getCell(4).getStringCellValue().length() == 0 ? 0 : Double.parseDouble(dataFormatter.formatCellValue(row.getCell(4)))));
        order.getDelivery().setAddress((dataFormatter.formatCellValue(row.getCell(3))));
        order.getCustomer().setPhone(dataFormatter.formatCellValue(row.getCell(5)));
        order.setTransferType(parseTransferType(row.getCell(3)));
        order.getDelivery().setComment(row.getCell(6) == null ? "" : dataFormatter.formatCellValue(row.getCell(6)));
        System.out.println(order.getDelivery().getAddress());
        return order;
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
        DeliveryTime deliveryTime = new DeliveryTime();
        LocalDate date = Instant.ofEpochMilli(dateCell.getDateCellValue().getTime()).atZone(ZoneId.systemDefault()).toLocalDate();

        if (timeCellValue.matches(before + ".*\\d+.*")) {
            LocalTime endTime = extractHoursAndMinutes(timeCellValue, before);
            deliveryTime.setStartTime(LocalDateTime.of(date, LocalTime.MIDNIGHT));
            deliveryTime.setEndTime(LocalDateTime.of(date, endTime));
            return deliveryTime;
        }

        if (timeCellValue.matches(after + ".*\\d+.*")) {
            LocalTime startTime = extractHoursAndMinutes(timeCellValue, after);
            deliveryTime.setStartTime(LocalDateTime.of(date, startTime));
            deliveryTime.setEndTime(LocalDateTime.of(date, LocalTime.MIDNIGHT.minusSeconds(1)));
            return deliveryTime;
        }

        if (timeCellValue.matches(".*\\d+.*" + before + ".*\\d+.*")) {
            String[] twoValues = timeCellValue.split("до");
            if (twoValues.length == 2) {
                extractFromTwoValues(deliveryTime, date, twoValues);
            }
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
        String stringForSplit = cellString.replace(prefix, "").replace("\\[a-zA-Z\\]\\*", "").trim();
        String[] splittedStringArray = stringForSplit.split("[:\\-.,]");
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
        hoursAndMinutes = LocalTime.of(Integer.parseInt(hours), Integer.parseInt(minutes));
        return hoursAndMinutes;
    }
}
