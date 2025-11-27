unit OSMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs
  , Vcl.StdCtrls
  , mormot.core.base
  , mormot.net.client
  , mormot.rest.http.client
  , uClient_OrderService
  , IOrderSystemInterfaces
  , uOS_Data
  ;

const
  SERVER_URI = 'localhost';
  SERVER_PORT = '8080';

const
  WM_SERVER_CONNECTSTATUS = WM_USER + 1;

type
  TServerConnectStatus = (scsOk, scsErrSynchronizeTimeStamp, scsErrLoginAdminUser, scsErrInitializeServices);

type
  TClientForm = class(TForm)
    private
      fOS_Service: TOrderSystemService;
    published
      property OrderService: TOrderSystemService read fOS_Service;
  end;
  TForm1 = class(TClientForm)
    btnAddOrderLine: TButton;
    btnAddProduct: TButton;
    btnAddOrder: TButton;
    lstOrders: TListBox;
    lbl1: TLabel;
    btnUpdateListOfOrders: TButton;
    procedure btnAddProductClick(Sender: TObject);
    procedure btnAddOrderClick(Sender: TObject);
    procedure btnAddOrderLineClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddCustomerClick(Sender: TObject);
    procedure btnUpdateListOfOrdersClick(Sender: TObject);
  private
                { Private declarations }
    fOS_Service: TOrderSystemService;
  public
                { Public declarations }
    property OS_Services: TOrderSystemService read fOS_Service;
  published
  end;

var
  Form1: TForm1;

implementation

uses
  uOS_AddNewCustomer
  , uOS_AddNewProduct
  , uOS_AddNewOrder
  , uOS_AddNewOrderLine
;
{$R *.dfm}


procedure TForm1.btnAddCustomerClick(Sender: TObject);
var
  frmNewCustomer: TfrmAddCustomer;
begin
  frmNewCustomer := TfrmAddCustomer.Create(self, OS_Services);
  frmNewCustomer.Enabled := true;
  frmNewCustomer.ShowModal;
end;

procedure TForm1.btnAddOrderClick(Sender: TObject);
var
  frmNewOrder: TfrmAddOrder;
begin
  frmNewOrder := TfrmAddOrder.Create(self, OS_Services);
  frmNewOrder.ShowModal;
end;

procedure TForm1.btnAddOrderLineClick(Sender: TObject);
var
  frmNewOrderLine: TfrmAddNewOrderLine;
begin
  frmNewOrderLine := TfrmAddNewOrderLine.Create(self, OS_Services);
  frmNewOrderLine.Show;
end;

procedure TForm1.btnAddProductClick(Sender: TObject);
var
  frmNewProduct: TfrmAddProduct;
begin
  frmNewProduct := TfrmAddProduct.Create(self, OS_Services);
  frmNewProduct.ShowModal;
end;


procedure TForm1.btnUpdateListOfOrdersClick(Sender: TObject);
var
  Service: IOrderSystem;
  Orders: TOrderArray;
  i: integer;
begin
  lstOrders.clear;
  OS_Services.Client.Resolve(IOrderSystem, Service);
  Service.RetrieveOrders(Orders);
  for i := 0 to High(Orders) do begin
     lstOrders.AddItem(Orders[i].OrderNo + ' : ' + Orders[i].CustomerID, Orders[i]);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fOS_Service := TOrderSystemService.create('localhost','8080');
  fOS_Service.InitializeServices;
end;


end.

