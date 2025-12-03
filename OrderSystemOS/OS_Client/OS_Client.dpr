program OS_Client;

uses
  Vcl.Forms,
  OSMain in 'OSMain.pas' {Form1},
  uOS_AddNewCustomer in 'uOS_AddNewCustomer.pas' {frmAddClient},
  uOS_AddNewOrder in 'uOS_AddNewOrder.pas' {frmAddOrder},
  uOS_AddNewOrderLine in 'uOS_AddNewOrderLine.pas' {frmAddNewOrderLine},
  uOS_Data in '..\OS_Server\uOS_Data.pas',
  IOrderSystemInterfaces in '..\OS_Server\IOrderSystemInterfaces.pas',
  uClient_OrderService in 'uClient_OrderService.pas',
  uOS_AddNewProduct in 'uOS_AddNewProduct.pas' {frmAddProduct};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
