/*
====Tính sức mua, tính số dư======
*/
Thay đổi số tiểu khoản: GetAFContractInfo 
	+ SetPPSE() -> (Tính lại sức mua)
	+ GetSecuritiesInfo() -> (Lấy thông tin chứng khoán) : Cũng gọi đến SetPPSE()
Thay đổi giá đặt: txtQuotePrice_Validating()
	+ SetPPSE() -> (Tính lại sức mua)
GetAFContractInfo: Gán giá trị -> Số dư: lblCI

Get_PP0_AFACTNO:   Gán giá trị -> Số dư: lblCI
	+ Hàm gọi đến Get_PP0_AFACTNO: GetAFContractInfo
Get_PPSE_AFACTNO:  Gán giá trị -> Số dư: lblPPSE
	+ Hàm gọi đến Get_PPSE_AFACTNO: txtQuoteQtty_Leave, txtEXPTPRICE_Leave.
	
GetAFContractInfo: gán -> mv_dblIsPPUsed, mv_strMarginType
	+ Hàm gọi đến GetAFContractInfo: ViewOrderMessage, frmODTransact_KeyUp, mskAFACCTNO_Validating, cboAFAcctno_SelectedIndexChanged
									 LoadRepoOrderInfo
