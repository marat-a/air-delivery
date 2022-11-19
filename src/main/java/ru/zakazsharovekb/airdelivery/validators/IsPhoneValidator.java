package ru.zakazsharovekb.airdelivery.validators;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.regex.Pattern;

public class IsPhoneValidator implements ConstraintValidator<IsPhone, String> {

    private boolean required;

    @Override
    public void initialize(IsPhone constraint) {
        required = constraint.required();
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if (value != null && required) {
            System.out.println(value);
//TODO Decompose regexp habr.com/ru/post/693622
            String regexp = "^(((\\+\\d{2}-)?0\\d{2,3}-\\d{7,8})|((\\+\\d{2}-)?(\\d{2,3}-)?([1][3,4,5,7,8][0-9]\\d{8})))$";
            boolean matches = Pattern.matches(regexp, value);
            System.out.println(matches);
            return matches;
        }
        return false;
    }
}