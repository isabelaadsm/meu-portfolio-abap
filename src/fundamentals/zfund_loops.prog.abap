*&---------------------------------------------------------------------*
*& Report  ZFUND_LOOPS
*&---------------------------------------------------------------------*
*& Topic: loops in ABAP.
*&---------------------------------------------------------------------*
REPORT zfund_loops.

TYPES: BEGIN OF ty_order,
         order_id TYPE i,
         customer TYPE string,
         country  TYPE c LENGTH 2,
         amount   TYPE p LENGTH 8 DECIMALS 2,
         status   TYPE c LENGTH 1,
       END OF ty_order.

DATA: lt_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY,
      ls_order  TYPE ty_order.

lt_orders = VALUE #(
  ( order_id = 1001 customer = 'Customer A' country = 'PT' amount = 1500 status = 'A' )
  ( order_id = 1002 customer = 'Customer B' country = 'BR' amount = 8000 status = 'B' )
  ( order_id = 1003 customer = 'Customer C' country = 'PT' amount = 450  status = 'A' )
  ( order_id = 1004 customer = 'Customer D' country = 'PT' amount = 7200 status = 'C' )
  ( order_id = 1005 customer = 'Customer E' country = 'DE' amount = 300  status = 'A' ) ).

*----------------------------------------------------------------------*
* Exercise 1: LOOP AT
* Scenario: list all orders (like an order overview report)
*----------------------------------------------------------------------*
WRITE: / '--- All orders ---'.
LOOP AT lt_orders INTO ls_order.
  WRITE: / sy-tabix, ls_order-order_id, ls_order-customer, ls_order-amount.
ENDLOOP.

*----------------------------------------------------------------------*
* Exercise 2: accumulate a total
* Scenario: total value of all orders
*----------------------------------------------------------------------*
DATA lv_total TYPE p LENGTH 10 DECIMALS 2.

LOOP AT lt_orders INTO ls_order.
  lv_total = lv_total + ls_order-amount.
ENDLOOP.
WRITE: / 'Total order value:', lv_total.

*----------------------------------------------------------------------*
* Exercise 3: LOOP AT ... WHERE
* Scenario: only open orders (status A)
*----------------------------------------------------------------------*
WRITE: / '--- Open orders ---'.
LOOP AT lt_orders INTO ls_order WHERE status = 'A'.
  WRITE: / ls_order-order_id, ls_order-customer.
ENDLOOP.

*----------------------------------------------------------------------*
* Exercise 4: CONTINUE and EXIT
* Scenario: skip foreign orders, stop at the first high-value one
*----------------------------------------------------------------------*
WRITE: / '--- Domestic orders until a high-value one ---'.
LOOP AT lt_orders INTO ls_order.
  IF ls_order-country <> 'PT'.
    CONTINUE.
  ENDIF.
  IF ls_order-amount > 5000.
    WRITE: / 'High-value order found, stopping:', ls_order-order_id.
    EXIT.
  ENDIF.
  WRITE: / 'Domestic order:', ls_order-order_id.
ENDLOOP.

*----------------------------------------------------------------------*
* Exercise 5: DO n TIMES
* Scenario: split a payment into 3 installments
*----------------------------------------------------------------------*
DATA lv_installment TYPE p LENGTH 10 DECIMALS 2.

lv_installment = lv_total / 3.
WRITE: / '--- Installments ---'.
DO 3 TIMES.
  WRITE: / 'Installment', sy-index, ':', lv_installment.
ENDDO.

*----------------------------------------------------------------------*
* Exercise 6: WHILE
* Scenario: how many lots to order to reach the minimum stock
*----------------------------------------------------------------------*
DATA: lv_stock    TYPE i VALUE 5,
      lv_min      TYPE i VALUE 50,
      lv_lot_size TYPE i VALUE 20,
      lv_lots     TYPE i.

WHILE lv_stock < lv_min.
  lv_stock = lv_stock + lv_lot_size.
  lv_lots  = lv_lots + 1.
ENDWHILE.
WRITE: / 'Lots to order:', lv_lots, '| Final stock:', lv_stock.

*----------------------------------------------------------------------*
* Exercise 7: READ TABLE (preview of internal tables)
* Scenario: find one specific order and check if it exists
*----------------------------------------------------------------------*
READ TABLE lt_orders INTO ls_order WITH KEY order_id = 1003.
IF sy-subrc = 0.
  WRITE: / 'Order found:', ls_order-order_id, ls_order-customer.
ELSE.
  WRITE: / 'Order not found'.
ENDIF.
