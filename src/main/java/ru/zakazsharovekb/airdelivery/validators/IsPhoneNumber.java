package ru.zakazsharovekb.airdelivery.validators;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.*;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

@Target({METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE})
@Retention(RUNTIME)
@Documented
@Constraint(validatedBy = IsPhoneNumberValidator.class)
public @interface IsPhoneNumber {
    boolean required() default true;
    String message() default "Неправильный номер телефона";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}