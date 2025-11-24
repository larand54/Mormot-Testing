unit uOS_AddNewCustomer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons
  , mormot.net.client
  , mormot.rest.http.client
  , uClient_OrderService
;
type
  TfrmAddCustomer = class(TForm)
    edCustomerName: TEdit;
    edCustomerID: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    fOSService: TOrderSystemService;
  public
    { Public declarations }
    constructor create(sender: TComponent; const pmcServer: TOrderSystemService); reintroduce;
    property OS_Server: TOrderSystemService read fOSService;
  end;

var
  frmAddCustomer: TfrmAddCustomer;

implementation

uses
  uOS_Data
  , IOrderSystemInterfaces
;

{$R *.dfm}

procedure TfrmAddCustomer.BitBtn1Click(Sender: TObject);
var
  newCustomer: TCustomer;
  service: IOrderSystem;
begin
  newCustomer := TCustomer.create;
  if not fOSService.Client.Resolve(IOrderSystem, service) then Exit; //=>
  newCustomer.Name := edCustomerName.text;
  newCustomer.CustomerID := getNewCustomerID(newCustomer.Name);
  service.AddCustomer(newCustomer);
end;


constructor TfrmAddCustomer.Create(sender: TComponent; const pmcServer: TOrderSystemService);
begin
  inherited create(sender);
  fOSService := pmcServer;
  Randomize;
end;

end.
