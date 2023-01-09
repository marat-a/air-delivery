package ru.zakazsharovekb.airdelivery.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Embeddable;
import java.time.LocalDateTime;

@Getter
@Setter
@Embeddable
public class DeliveryTime {

    private LocalDateTime startTime;

    private LocalDateTime endTime;

}
