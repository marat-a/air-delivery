package ru.zakazsharovekb.airdelivery.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Embeddable;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@Embeddable
public class DeliveryTime {

    private LocalDateTime startTime;
    private LocalDateTime endTime;

}
