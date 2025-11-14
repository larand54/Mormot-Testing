program OrderSystemOS;

uses
  Vcl.Forms,
  OSMain in 'OSMain.pas' {Form1},
  uOS_AddNewClient in 'uOS_AddNewClient.pas' {frmAddClient},
  uOS_AddNewProduct in 'uOS_AddNewProduct.pas' {frmAddProduct},
  uOS_AddNewOrder in 'uOS_AddNewOrder.pas' {frmAddOrder},
  uOS_AddNewOrderLine in 'uOS_AddNewOrderLine.pas' {frmAddNewOrderLine},
  uOS_Data in 'uOS_Data.pas',
  uOS_Server in 'uOS_Server.pas',
  uOS_AddNewOrderLineVS1 in 'uOS_AddNewOrderLineVS1.pas' {frmAddNewOrderLineVS1};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TForm1, Form1);
  // Application.CreateForm(TfrmAddClient, frmAddClient);
  // Application.CreateForm(TfrmAddProduct, frmAddProduct);
  // Application.CreateForm(TfrmAddOrder, frmAddOrder);
  // Application.CreateForm(TfrmAddNewOrderLine, frmAddNewOrderLine);
  Application.Run;

end.
