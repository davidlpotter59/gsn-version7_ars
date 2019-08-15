/* PRSCOLLECT.EQ */
/* THIS PROGRAM EXTRACTS THE PREMIUM DATA FOR A GIVEN DATE
   RANGE

        WHITE HALL MUTUAL INSURANCE COMPANY

        MARCH 12, 1993
*/

DEFINE DATE
     START_DATE[6]=PARAMETER/CLS/PROMPT="ENTER START DATE ? "

     END_DATE[6]=PARAMETER/PROMPT="ENTER END DATE ? "
    VALID IF END_DATE => START_DATE

FIND  arsbilling WITH

/* TRANSACTED PRIOR TO START DATE WITH EFFECTIVE DATES WITHIN
   THE START DATE AND THE END DATE */

((arsbilling:TRANS_DATE < START_DATE AND
 arsbilling:TRANS_EFF => START_DATE AND
 arsbilling:TRANS_EFF <= END_DATE) OR

/* TRANSACTED WITHIN THE START DATE AND THE END DATE WITH
   EFFECTIVE DATES NOT > THE END_DATE */

(arsbilling:TRANS_DATE => START_DATE AND
 arsbilling:TRANS_DATE <= END_DATE AND
 arsbilling:TRANS_EFF <= END_DATE))

and

arsbilling:trans_eff <> arsbilling:trans_exp

and

 arsbilling:installment_amount  <> 0
;
