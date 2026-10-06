*&---------------------------------------------------------------------*
*& Report  ZFUND_CONDITIONALS
*&---------------------------------------------------------------------*
*& Topic: conditionals in ABAP.
*&---------------------------------------------------------------------*
REPORT zfund_conditionals.

*----------------------------------------------------------------------*
* Exercise 1: stock check (IF / ELSEIF / ELSE)
* Scenario: decide if a material needs replenishment
*----------------------------------------------------------------------*
DATA: lv_stock     TYPE i VALUE 15,
      lv_min_stock TYPE i VALUE 20.

IF lv_stock = 0.
  WRITE: / 'Out of stock: urgent purchase requisition'.
ELSEIF lv_stock < lv_min_stock.
  WRITE: / 'Below minimum stock: create purchase requisition'.
ELSE.
  WRITE: / 'Stock level OK'.
ENDIF.

*----------------------------------------------------------------------*
* Exercise 2: credit check and approval (AND / OR)
* Scenario: block risky orders, require approval for large ones
*----------------------------------------------------------------------*
DATA: lv_order_value   TYPE i VALUE 12000,
      lv_credit_limit  TYPE i VALUE 10000,
      lv_has_overdue   TYPE abap_bool VALUE abap_false,
      lv_customer_type TYPE c LENGTH 3 VALUE 'STD'.

IF lv_order_value > lv_credit_limit OR lv_has_overdue = abap_true.
  WRITE: / 'Order blocked: credit check failed'.
ENDIF.

IF lv_order_value > 10000 AND lv_customer_type <> 'VIP'.
  WRITE: / 'Manager approval required'.
ENDIF.

*----------------------------------------------------------------------*
* Exercise 3: NOT with parentheses
* Scenario: orders outside Portugal and Brazil need customs documents
*----------------------------------------------------------------------*
DATA lv_country TYPE c LENGTH 2 VALUE 'US'.

IF NOT ( lv_country = 'PT' OR lv_country = 'BR' ).
  WRITE: / 'Export order: extra customs documents needed'.
ENDIF.

*----------------------------------------------------------------------*
* Exercise 4: CASE
* Scenario: overall status of a sales document (A, B, C)
*----------------------------------------------------------------------*
DATA lv_status TYPE c LENGTH 1 VALUE 'B'.

CASE lv_status.
  WHEN 'A'.
    WRITE: / 'Not yet processed'.
  WHEN 'B'.
    WRITE: / 'Partially processed'.
  WHEN 'C'.
    WRITE: / 'Completely processed'.
  WHEN OTHERS.
    WRITE: / 'Unknown status'.
ENDCASE.

*----------------------------------------------------------------------*
* Exercise 5: field validation (IS INITIAL, BETWEEN, CP)
* Scenario: check user input before saving a document
*----------------------------------------------------------------------*
DATA: lv_material TYPE c LENGTH 18,
      lv_quantity TYPE i VALUE 150,
      lv_program  TYPE c LENGTH 30 VALUE 'ZFUND_LOOPS'.

IF lv_material IS INITIAL.
  WRITE: / 'Error: material number is mandatory'.
ENDIF.

IF lv_quantity BETWEEN 1 AND 999.
  WRITE: / 'Quantity within allowed range'.
ENDIF.

IF lv_program CP 'Z*'.
  WRITE: / 'Custom program (starts with Z)'.
ENDIF.

*----------------------------------------------------------------------*
* Exercise 6: COND and SWITCH
* Scenario: build a status text in one expression
*----------------------------------------------------------------------*
DATA(lv_stock_text) = COND string( WHEN lv_stock = 0              THEN 'Out of stock'
                                   WHEN lv_stock < lv_min_stock   THEN 'Low stock'
                                   ELSE 'OK' ).

DATA(lv_status_text) = SWITCH string( lv_status
                                      WHEN 'A' THEN 'Open'
                                      WHEN 'B' THEN 'In process'
                                      WHEN 'C' THEN 'Completed'
                                      ELSE 'Unknown' ).

WRITE: / 'Stock:', lv_stock_text.
WRITE: / 'Status:', lv_status_text.
