unit UWebFloodInsight;

interface

uses
  SysUtils, Classes, HTTPApp, {IdHTTP,} XMLIntf,XMLDoc,IdGlobal,DateUtils,
  Windows,IniFiles, WebReq;
type
  TWebFloodInsights = class(TWebModule)
    procedure WebModule1WebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1WebActionItem2Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1WebActionItem3Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebFloodInsightsWebActionItem4Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
  public
  end;

var
  WebFloodInsights: TWebFloodInsights;

implementation
uses uFloodMap;
{$R *.DFM}

//General
procedure TWebFloodInsights.WebModule1WebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  try
    Response.Content :=
      '<html><head><title>Flood Mapping Web Service 3.0</title></head>' +
      '<body><h3><b>Bradford Technologies Inc.</b></h3>Flood Mapping Web Service 3.0</body></html>';
  except
      on E: Exception do
        Response.Content := '<html><head><title>Error </title></head>' + '<body>'+ 'Error: '+ E.Message +'</body></html>';
  end;
  Handled := True;
end;

//Get Flood Info
procedure TWebFloodInsights.WebModule1WebActionItem2Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var sRetMsg: String;
    TempFloodMap: TFloodMap;
begin
  try
    try
      //instantiate the FloodMap Class
      TempFloodMap := TFloodMap.Create(Self);

      {  Log does not work until we finishe parsing
      TempFloodMap.WriteToLogFile('<HR>');
      TempFloodMap.WriteToLogFile('TFloodMap Instantiated to GetInfo()');

      TempFloodMap.WriteToLogFile('Start ParseConfiguration');  }

      if not TempFloodMap.ParseConfiguration() then
      raise Exception.Create('Error: The Flood Insights Server cann''t be initialized. Please inform your administrator.');

      //TempFloodMap.WriteToLogFile('End ParseConfiguration');

      //set global variable
      TempFloodMap.SERVICE_ID    := 1;
      TempFloodMap.WSDL_LOCATION := 'http://localhost/WSSubscriptionGalaxy/SubscriptionService.asmx/';
      //TempFloodMap.WSDL_LOCATION := 'yatoma/WSSubscriptionGalaxy/SubscriptionService.asmx/';
      TempFloodMap.WS_PIN        := '0x0100F20CCD0C9B0A8144B434BFA6DBBCF081A977AC8ADA8D99E121DCFBC7112A50B0DA261B7CD314F2AAB2996A5B';
      TempFloodMap.gUsageFlag := False;


      //customer authentication
      TempFloodMap.GICustomerId          := Request.QueryFields.Values['CustomerId'];
      TempFloodMap.GICustomerPin         := Request.QueryFields.Values['CustomerPin'];

      if StrtoIntDef(Request.QueryFields.Values['txtReturnMap'], -1) = 0 then
        TempFloodMap.SERVICE_ID := 10;  //Flood Data only, else flood map: Service_ID = 1
      TempFloodMap.WriteToLogFile('Start UserHasAccess');
      sRetMsg := TempFloodMap.UserHasAccess(TempFloodMap.GICustomerId, TempFloodMap.GICustomerPin);

      TempFloodMap.WriteToLogFile('End UserHasAccess');

      if (Pos('ERROR',sRetMsg) > 0) or (Pos('Error',sRetMsg) > 0) or (Pos('NOTICE',sRetMsg) > 0) then
        raise Exception.Create(sRetMsg);

      //read client request in local variables
      TempFloodMap.GItxtText             := Request.QueryFields.Values['txtText'];
      TempFloodMap.GItxtStreet           := Request.QueryFields.Values['txtStreet'];
      TempFloodMap.GItxtCity             := Request.QueryFields.Values['txtCity'];
      TempFloodMap.GItxtState            := Request.QueryFields.Values['txtState'];
      TempFloodMap.GItxtZip              := Request.QueryFields.Values['txtZip'];
      TempFloodMap.GItxtPlus4            := Request.QueryFields.Values['txtPlus4'];

      //TempFloodMap.GItxtUserName         := TempFloodMap.gUSERNAME;
      //TempFloodMap.GItxtPassword         := TempFloodMap.gPASSWORD;
      //TempFloodMap.GItxtMemberId         := '';
      //TempFloodMap.GIClientVersion       := TempFloodMap.gCLIENTVERSION;
      //TempFloodMap.GIClientSessionId     := TempFloodMap.gSESSIONID;

      TempFloodMap.GIMapHeight           := Request.QueryFields.Values['txtMapHeight'];
      TempFloodMap.GIMapWidth            := Request.QueryFields.Values['txtMapWidth'];
      TempFloodMap.GIMapZoom             := Request.QueryFields.Values['txtMapZoom'];

      if Length(TempFloodMap.GIMapZoom) = 0 then TempFloodMap.GIMapZoom := '0';


      //save the IP for trasaction logging
      TempFloodMap.GICustomerIP := Request.RemoteAddr;

      //call the GetInfo() to get the map
      TempFloodMap.WriteToLogFile('Start GetInfo()');
      Response.content := TempFloodMap.GetInfo();
      TempFloodMap.WriteToLogFile('End GetInfo()');

      //log the trasaction
      if TempFloodMap.gUsageFlag then
      begin
         sRetMsg := TempFloodMap.AddServiceUsage(1,1); //success
         if sRetMsg <> 'Success' then raise Exception.Create(sRetMsg);
      end;
      TempFloodMap.WriteToLogFile('Success GetInfo');
    except
      on E: Exception do
      begin
         sRetMsg := TempFloodMap.AddServiceUsage(2,1); //bad
         Response.Content := 'Error: '+ E.Message;
         TempFloodMap.WriteToLogFile('WebItemAction2 Exception: ' + E.Message);
      end;
    end;
  finally
    begin
      FreeAndNil(TempFloodMap);
      Handled := True;
    end;
  end;
end;

procedure TWebFloodInsights.WebModule1WebActionItem3Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  var sRetMsg: string;
  TempFloodMap: TFloodMap;
begin
  try
    try
      //instantiate the FloodMap Class
      TempFloodMap:= TFloodMap.Create(Self);

      {TempFloodMap.WriteToLogFile('TFloodMap instantiated to GetMap()');

      TempFloodMap.WriteToLogFile('<HR>');
      TempFloodMap.WriteToLogFile('TFloodMap Instantiated to GetMap()...');

      TempFloodMap.WriteToLogFile('Start ParseConfiguration ');  }

      if not TempFloodMap.ParseConfiguration() then
      raise Exception.Create('Error: The Flood Insights Server cann''t be initialized. Please inform your administrator.');
      //TempFloodMap.WriteToLogFile('End ParseConfiguration ');

      //set global variable
      TempFloodMap.SERVICE_ID    := 1;
      TempFloodMap.WSDL_LOCATION := 'http://localhost/WSSubscriptionGalaxy/SubscriptionService.asmx/';
      TempFloodMap.WS_PIN        := '0x0100F20CCD0C9B0A8144B434BFA6DBBCF081A977AC8ADA8D99E121DCFBC7112A50B0DA261B7CD314F2AAB2996A5B';
      TempFloodMap.gUsageFlag := False;

      //customer authentication
      TempFloodMap.GMCustomerId   := Request.QueryFields.Values['CustomerId'];
      TempFloodMap.GMCustomerPin  := Request.QueryFields.Values['CustomerPin'];

      TempFloodMap.WriteToLogFile('Start UserHasAccess ');
      sRetMsg := TempFloodMap.UserHasAccess(TempFloodMap.GMCustomerId, TempFloodMap.GMCustomerPin);
      TempFloodMap.WriteToLogFile('End UserHasAccess ');

      if (Pos('ERROR',sRetMsg) > 0) or (Pos('Error',sRetMsg) > 0) or (Pos('NOTICE',sRetMsg) > 0) then
        raise Exception.Create(sRetMsg);

      //read client request in local variables
      TempFloodMap.GMtxtText             := Request.QueryFields.Values['txtText'];
      TempFloodMap.GMtxtStreet           := Request.QueryFields.Values['txtStreet'];
      TempFloodMap.GMtxtCity             := Request.QueryFields.Values['txtCity'];
      TempFloodMap.GMtxtState            := Request.QueryFields.Values['txtState'];
      TempFloodMap.GMtxtZip              := Request.QueryFields.Values['txtZip'];
      TempFloodMap.GMtxtPlus4            := Request.QueryFields.Values['txtPlus4'];
      TempFloodMap.GMtxtLon              := Request.QueryFields.Values['txtLon'];
      TempFloodMap.GMtxtLat              := Request.QueryFields.Values['txtLat'];
      TempFloodMap.GMtxtGeoResult        := Request.QueryFields.Values['txtGeoResult'];
      TempFloodMap.GMtxtCensusBlockId    := Request.QueryFields.Values['txtCensusBlockId'];

      //TempFloodMap.GMtxtUserName         := gUSERNAME;
      //TempFloodMap.GMtxtPassword         := gPASSWORD;
      //TempFloodMap.GMtxtMemberId         := '';
      //TempFloodMap.GMClientVersion       := gCLIENTVERSION;
      //TempFloodMap.GMClientSessionId     := gSESSIONID;

      TempFloodMap.GMtxtGenMapImage      := 'True';
      TempFloodMap.GMtxtZoom             := '0';
      TempFloodMap.GMtxtLocLabel         := 'Subject';
      TempFloodMap.GMtxtRmTestList       := 'Flood,True';
      TempFloodMap.GMtxtMapHeight        := Request.QueryFields.Values['txtMapHeight'];
      TempFloodMap.GMtxtMapWidth         := Request.QueryFields.Values['txtMapWidth'];
      TempFloodMap.GMtxtZoom             := Request.QueryFields.Values['txtZoom'];
      if Length(TempFloodMap.GMtxtZoom) = 0 then TempFloodMap.GMtxtZoom := '0';

      //save the IP for trasaction logging
      TempFloodMap.GMCustomerIP := Request.RemoteAddr;

      //call the GetInfo() to get the map
      TempFloodMap.WriteToLogFile('Start GetMap ');
      Response.content := TempFloodMap.GetMap();
      TempFloodMap.WriteToLogFile('End GetMap ');

      //log the trasaction
      //log the trasaction
      if TempFloodMap.gUsageFlag then
      begin
         sRetMsg := TempFloodMap.AddServiceUsage(1,2); //success
         if sRetMsg <> 'Success' then raise Exception.Create(sRetMsg);
      end;
      TempFloodMap.WriteToLogFile('Success GetMap()');

    except
      on E: Exception do
      begin
        sRetMsg := TempFloodMap.AddServiceUsage(2,2); //bad
        Response.Content := 'Error: '+ E.Message;
      end;
    end;
  finally
    begin
      FreeAndNil(TempFloodMap);
      Handled := True;
    end;
  end;
end;

procedure TWebFloodInsights.WebFloodInsightsWebActionItem4Action(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
  var
  //sRetMsg: string;
  TempFloodMap: TFloodMap;
begin
  try
    try
      //instantiate the FloodMap Class
      TempFloodMap:= TFloodMap.Create(Self);

      {TempFloodMap.WriteToLogFile('TFloodMap instantiated to GetSpottedMapInfo()');

      TempFloodMap.WriteToLogFile('<HR>');
      TempFloodMap.WriteToLogFile('TFloodMap Instantiated to GetSpottedMapInfo()...');

      TempFloodMap.WriteToLogFile('Start ParseConfiguration '); }

      if not TempFloodMap.ParseConfiguration() then
      raise Exception.Create('Error: The Flood Insights Server cann''t be initialized. Please inform your administrator.');
     // TempFloodMap.WriteToLogFile('End ParseConfiguration ');

      //set global variable
     { No needs to validate the flood service: it is free for respotting
      TempFloodMap.SERVICE_ID    := 1;
      TempFloodMap.WSDL_LOCATION := 'http://localhost/WSSubscriptionGalaxy/SubscriptionService.asmx/';
      TempFloodMap.WS_PIN        := '0x0100F20CCD0C9B0A8144B434BFA6DBBCF081A977AC8ADA8D99E121DCFBC7112A50B0DA261B7CD314F2AAB2996A5B';
      TempFloodMap.gUsageFlag := False;

      //customer authentication
      TempFloodMap.GMCustomerId   := Request.QueryFields.Values['CustomerId'];
      TempFloodMap.GMCustomerPin  := Request.QueryFields.Values['CustomerPin'];

      TempFloodMap.WriteToLogFile('Start UserHasAccess ');
      sRetMsg := TempFloodMap.UserHasAccess(TempFloodMap.GMCustomerId, TempFloodMap.GMCustomerPin);
      TempFloodMap.WriteToLogFile('End UserHasAccess ');

      if (Pos('ERROR',sRetMsg) > 0) or (Pos('Error',sRetMsg) > 0) or (Pos('NOTICE',sRetMsg) > 0) then
        raise Exception.Create(sRetMsg);    }

      //read client request in local variables
      TempFloodMap.GMtxtText             := Request.QueryFields.Values['txtText'];
      TempFloodMap.GMtxtStreet           := Request.QueryFields.Values['txtStreet'];
      TempFloodMap.GMtxtCity             := Request.QueryFields.Values['txtCity'];
      TempFloodMap.GMtxtState            := Request.QueryFields.Values['txtState'];
      TempFloodMap.GMtxtZip              := Request.QueryFields.Values['txtZip'];
      TempFloodMap.GMtxtPlus4            := Request.QueryFields.Values['txtPlus4'];
      TempFloodMap.GMtxtLon              := Request.QueryFields.Values['txtLon'];
      TempFloodMap.GMtxtLat              := Request.QueryFields.Values['txtLat'];
      TempFloodMap.GMtxtGeoResult        := Request.QueryFields.Values['txtGeoResult'];
      TempFloodMap.GMtxtCensusBlockId    := Request.QueryFields.Values['txtCensusBlockId'];


      TempFloodMap.GMtxtGenMapImage      := 'True';
      TempFloodMap.GMtxtLocLabel         := 'Subject';
      TempFloodMap.GMtxtRmTestList       := 'Flood,True';
      TempFloodMap.GMtxtMapHeight        := Request.QueryFields.Values['txtMapHeight'];
      TempFloodMap.GMtxtMapWidth         := Request.QueryFields.Values['txtMapWidth'];

      //added variables for respotting
      TempFloodMap.GMtxtZoom             := Request.QueryFields.Values['txtZoom'];
      if Length(TempFloodMap.GMtxtZoom) = 0 then TempFloodMap.GMtxtZoom := '0';
      TempFloodMap.GMtxtLocPtX           := Request.QueryFields.Values['txtLocPtX'];
      TempFloodMap.GMtxtLocPtY           := Request.QueryFields.Values['txtLocPtY'];
      TempFloodMap.GMtxtImageID          := Request.QueryFields.Values['txtImageID'];
      TempFloodMap.GMtxtImageURL         := Request.QueryFields.Values['txtImageURL'];

      //save the IP for trasaction logging
      TempFloodMap.GMCustomerIP := Request.RemoteAddr;

      //call the GetInfo() to get the map
      TempFloodMap.WriteToLogFile('Start GetSpottedMapInfo');
      Response.content := TempFloodMap.GetReSpottedMapInfo();
      TempFloodMap.WriteToLogFile('End GetSpottedMapInfo ');

      //log the trasaction
      //log the trasaction
      {  now needs update flood usage for respoting it is free
      if TempFloodMap.gUsageFlag then
      begin
         sRetMsg := TempFloodMap.AddServiceUsage(1,2); //success
         if sRetMsg <> 'Success' then raise Exception.Create(sRetMsg);
      end;   }
      TempFloodMap.WriteToLogFile('Success GetSpottedMapInfo()');

    except
      on E: Exception do
      begin
       { sRetMsg := TempFloodMap.AddServiceUsage(2,2); //bad
        Response.Content := 'Error: '+ E.Message;    }
        TempFloodMap.WriteToLogFile('WebActionItem4 Exception: ' + E.Message);
      end;
    end;
  finally
    begin
      FreeAndNil(TempFloodMap);
      Handled := True;
    end;
  end;
end;

end.
