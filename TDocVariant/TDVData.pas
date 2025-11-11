unit TDVData;
interface
uses
  System.SysUtils
  , mormot.core.base
  , mormot.orm.base      // Required by "AS_UNIQUE"
  , mormot.orm.core
;

type
  TOrmTDV = class(TOrm)
  private
    fName: RawUTF8;
    fAge: integer;
    fData: variant;
  published
    property Name: RawUTF8 read fName write fName stored AS_UNIQUE;
    property Age: integer read fAge write fAge;
    property Data: variant read fData write fData;
  end;

  TOrmT1 = class(TOrm)
  private
    fName: RawUTF8;
    fAge: integer;
  published
    property Name: RawUTF8 read fName write fName stored AS_UNIQUE;
    property Age: integer read fAge write fAge;
  end;

  TOrmSample = class(TOrm)
  private
    FName: RawUTF8;
    FQuestion: RawUTF8;
    FTime: TModTime;
  published
    property Name: RawUTF8 read FName write FName;
    property Question: RawUTF8 read FQuestion write FQuestion;
    property Time: TModTime read FTime write FTime;
  end;

function CreateSampleModel: TOrmModel;

implementation
function CreateSampleModel: TOrmModel;
begin
  result := TOrmModel.Create([TOrmTDV, TOrmT1, TOrmSample]);
end;

end.
