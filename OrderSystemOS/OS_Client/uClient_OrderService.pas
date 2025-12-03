unit uClient_OrderService;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs
  , Vcl.StdCtrls
  , mormot.core.base
  , mormot.orm.core
  , mormot.net.client
  , mormot.rest.http.client
  ;

const
  ROOT_NAME_FILE = 'root' ;     // Define URL-Base as: http://localhost/root/
type
  TOrderSystemService = class(TObject)
  strict private
    FClient: TRestHttpClient;
  public
    constructor Create(const pmcServerURI: RawUtf8; const pmcServerPort: RawUtf8);
    destructor Destroy; override;
    function InitializeServices: Boolean;
    property Client: TRestHttpClient read FClient;
  end;

implementation
uses
  IOrderSystemInterfaces
  , mormot.soa.core
;
{ TOrderService }

constructor TOrderSystemService.Create(const pmcServerURI, pmcServerPort: RawUtf8);
const
  TIMEOUT: Cardinal = 2000;  // 2 sec
begin
  inherited Create;
  FClient := TRestHttpClient.Create(pmcServerURI, pmcServerPort, TOrmModel.Create([], ROOT_NAME_FILE), False, '', '', TIMEOUT, TIMEOUT, TIMEOUT);
  FClient.Model.Owner := FClient;
end;

destructor TOrderSystemService.Destroy;
begin
  FreeAndNil(FClient);
  inherited;
end;

function TOrderSystemService.InitializeServices: Boolean;
begin
  Result := False;
  if Client.SessionID > 0 then
  try
    // The check before registering the service with ServiceDefine() is only necessary because the
    // user can be changed and the initialization is executed again. This is normally not the case.
    Result := (Client.ServiceContainer.Info(IOrderSystem) <> Nil) or Client.ServiceDefine([IOrderSystem], sicShared);
  except
  end;
end;

end.
