unit OSMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnAddClient: TButton;
    btnAddOrderLine: TButton;
    btnAddProduct: TButton;
    btnAddOrder: TButton;
    Button1: TButton;
    btnAddOrderLine_Simple: TButton;
    procedure btnAddClientClick(Sender: TObject);
    procedure btnAddProductClick(Sender: TObject);
    procedure btnAddOrderClick(Sender: TObject);
    procedure btnAddOrderLineClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
                { Private declarations }
  public
                { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uOS_AddNewClient
  , uOS_AddNewProduct
  , uOS_AddNewOrder
  , uOS_AddNewOrderLine
  , uOS_AddNewOrderLineVS1
  , uOS_Server
;
{$R *.dfm}

procedure TForm1.btnAddClientClick(Sender: TObject);
var
  frmNewClient: TfrmAddClient;
begin
  frmNewClient := TfrmAddClient.Create(self);
  frmNewClient.ShowModal;
end;

procedure TForm1.btnAddOrderClick(Sender: TObject);
var
  frmNewOrder: TfrmAddOrder;
begin
  frmNewOrder := TfrmAddOrder.Create(self);
  frmNewOrder.ShowModal;
end;

procedure TForm1.btnAddOrderLineClick(Sender: TObject);
var
  frmNewOrderLine: TfrmAddNewOrderLine;
begin
  frmNewOrderLine := TfrmAddNewOrderLine.Create(self);
  frmNewOrderLine.ShowModal;
end;

procedure TForm1.btnAddProductClick(Sender: TObject);
var
  frmNewProduct: TfrmAddProduct;
begin
  frmNewProduct := TfrmAddProduct.Create(self);
  frmNewProduct.ShowModal;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  frmNewOrderLineVS1: TfrmAddNewOrderLineVS1;
begin
  frmNewOrderLineVS1 := TfrmAddNewOrderLineVS1.Create(self);
  frmNewOrderLineVS1.ShowModal;
end;

end.

