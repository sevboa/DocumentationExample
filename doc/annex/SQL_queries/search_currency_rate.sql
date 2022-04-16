SELECT
    CURRENCY_RATE_TYPE.CODE AS 'currencyRateTypeCode',
    ARRAY(
        SELECT OFFICE_CODE_ZAGAR_CURRENCY_RATE.OFFICECODE
        FROM OFFICE_CODE_ZAGAR_CURRENCY_RATE
        WHERE OFFICE_CODE_ZAGAR_CURRENCY_RATE.ZAGARCURRENCYRATE_ID = ZAGAR_CURRENCY_RATE.ID
        ORDER BY OFFICE_CODE_ZAGAR_CURRENCY_RATE.OFFICECODE ASC
        ) AS 'bankOfficeCodes',
    ZAGAR_CURRENCY_RATE.EXCHANGERATELIMITFROM AS 'exchangeRateLimitFrom',
    ZAGAR_CURRENCY_RATE.EXCHANGERATELIMITTO AS 'exchangeRateLimitTo',
    ZAGAR_CURRENCY_RATE.BASECURRENCYSIGNCODE AS 'baseCurrencySignCode',
    ZAGAR_CURRENCY_RATE.BASECURRENCYDIGITCODE AS 'baseCurrencyDigitCode',
    ZAGAR_CURRENCY_RATE.QUOTEDCURRENCYSIGNCODE AS 'quotedCurrencySignCode',
    ZAGAR_CURRENCY_RATE.QUOTEDCURRENCYDIGITCODE AS 'quotedCurrencyDigitCode',
    ZAGAR_CURRENCY_RATE.BASECURRENCYSCALE AS 'baseCurrencyScale',
    ZAGAR_CURRENCY_RATE.QUOTEDCURRENCYSCALE AS 'quotedCurrencyScale',
    ZAGAR_CURRENCY_RATE.BUYRATE AS 'buyRate',
    ZAGAR_CURRENCY_RATE.SELLRATE AS 'sellRate',
    ZAGAR_CURRENCY_RATE.VALIDFROM AS 'validFrom'
FROM ZAGAR_CURRENCY_RATE
INNER JOIN ZAGAR_PRODUCT_GROUP ON ZAGAR_PRODUCT_GROUP.CODE = ZAGAR_CURRENCY_RATE.ZAGARPRODUCTGROUP_CODE
INNER JOIN CURRENCY_RATE_TYPE ON CURRENCY_RATE_TYPE.ID = ZAGAR_PRODUCT_GROUP.CURRENCYRATETYPE_ID
-- если в запросе заполнено поле bankOfficeCodes
    INNER JOIN OFFICE_CODE_ZAGAR_CURRENCY_RATE ON OFFICE_CODE_ZAGAR_CURRENCY_RATE.ZAGARCURRENCYRATE_ID = ZAGAR_CURRENCY_RATE.ID
WHERE
    CURRENCY_RATE_TYPE.CODE = $currencyRateTypeCode
    AND ZAGAR_CURRENCY_RATE.VALIDFROM <= NOW()
    AND ZAGAR_CURRENCY_RATE.VALIDTO > NOW()
    -- если в запросе заполнено поле bankOfficeCodes
        AND (
            OFFICE_CODE_ZAGAR_CURRENCY_RATE.CODE IN $bankOfficeCodes
            OR OFFICE_CODE_ZAGAR_CURRENCY_RATE.CODE = '0'
        )
    -- если в запросе заполнено поле currencyExchangeAmount
        AND ZAGAR_CURRENCY_RATE.EXCHANGERATELIMITFROM <= $currencyExchangeAmount
        AND (
            ZAGAR_CURRENCY_RATE.EXCHANGERATELIMITTO > $currencyExchangeAmount
            OR ZAGAR_CURRENCY_RATE.EXCHANGERATELIMITTO IS NULL
        )
    -- если в запросе заполнено поле baseCurrencySignCode
        AND ZAGAR_CURRENCY_RATE.BASECURRENCYSIGNCODE = $baseCurrencySignCode
    -- если в запросе заполнено поле baseCurrencyDigitCode
        AND ZAGAR_CURRENCY_RATE.BASECURRENCYDIGITCODE = $baseCurrencyDigitCode
    -- если в запросе заполнено поле quotedCurrencySignCode
        AND ZAGAR_CURRENCY_RATE.QUOTEDCURRENCYSIGNCODE = $quotedCurrencySignCode
    -- если в запросе заполнено поле quotedCurrencyDigitCode
        AND ZAGAR_CURRENCY_RATE.QUOTEDCURRENCYDIGITCODE = $quotedCurrencyDigitCode
GROUP BY ZAGAR_CURRENCY_RATE.ID