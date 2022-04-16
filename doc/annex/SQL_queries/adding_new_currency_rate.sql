(
    INSERT INTO ZAGAR_CURRENCY_RATE
    (
        ID, 
        ZAGARPRODUCTGROUP_CODE,
        EXCHANGERATELIMITFROM,
        BASECURRENCYSIGNCODE,
        BASECURRENCYDIGITCODE,
        QUOTEDCURRENCYSIGNCODE,
        QUOTEDCURRENCYDIGITCODE,
        BASECURRENCYSCALE,
        QUOTEDCURRENCYSCALE,
        BUYRATE,
        SELLRATE,
        VALIDFROM
    )
    VALUES
    (
        NF_CURRENCY_RATE_SEQ.NEXTVAL,
        $productGroupCode,
        $limit,
        $baseCurrencySignCode,
        $baseCurrencyDigitCode,
        $quotedCurrencySignCode,
        $quotedCurrencyDigitCode,
        $baseCurrencyScale,
        1,
        $buyRate,
        $sellRate,
        $validFrom
    )
    RETURNING ID
) as temp
INSERT INTO OFFICE_CODE_ZAGAR_CURRENCY_RATE
(
    ID,
    ZAGARCURRENCYRATE_ID,
    OFFICECODE
)
VALUES
(
    NF_CURRENCY_RATE_SEQ.NEXTVAL,
    temp.ID,
    $officeCode[0]
),
(
    NF_CURRENCY_RATE_SEQ.NEXTVAL,
    temp.ID,
    $officeCode[1]
),
...
;