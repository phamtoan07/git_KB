--tao cac sequence tren timesten
CREATE INDEX idx_accounts_banklink ON accounts(banklink);
CREATE INDEX idx_quotes_quoteid ON quotes(quoteid);
CREATE INDEX  idx_orders_originorderid ON orders (originorderid);
CREATE INDEX idx_orders_confirmid ON orders(confirmid ASC );
CREATE INDEX idx_orders_ACCTNO ON orders(ACCTNO ASC);
CREATE INDEX idx_orders_custodycd ON orders(custodycd ASC);
CREATE INDEX idx_orders_quoteid ON orders(quoteid ASC); 
CREATE INDEX idx_trades ON trades (orderid  ASC );
--CREATE INDEX idx_portfolios_acctno ON  portfolios(acctno);
CREATE INDEX idx_portfolios_symbol ON  portfolios(symbol);
CREATE INDEX idx_ACCOUNTS_FORMULACD ON  ACCOUNTS(FORMULACD);
 