unit uFloodMap;

interface
uses
  SysUtils, Classes, {IdHTTP} AxCtrls, WinHttp_TLB, ActiveX, HTTPApp, XMLIntf, XMLDoc, IniFiles, DateUtils, Windows, Math;
type
  TFloodMap = class(TComponent)
  private
  { Private declarations }
    FSERVICE_ID: Integer;
    FWSDL_LOCATION: String;
    FWS_PIN: String;
    FgUsageFlag: Boolean;

    FGItxtText: String;
    FGItxtStreet: String;
    FGItxtCity: String;
    FGItxtState: String;
    FGItxtZip: String;
    FGItxtPlus4: String;
    FGItxtUserName: String;
    FGItxtPassword: String;
    FGItxtMemberId: String;
    FGIClientVersion: String;
    FGIClientSessionId: String;
    FGIMapHeight : String;
    FGIMapWidth: String;
    FGIMapZoom: String;


    {additional required info used for our authentication & trasaction tracking}
    FGICustomerId: String;
    FGICustomerPin: String;
    FGICustomerIP: String;

    //variables for GetMap() function, variable prefix GM=GetMap
    FGMtxtStreet: String;
    FGMtxtCity: String;
    FGMtxtState: String;
    FGMtxtZip: String;
    FGMtxtPlus4: String;
    FGMtxtLon: String;
    FGMtxtLat: String;
    FGMtxtGeoResult: String;
    FGMtxtCensusBlockId: String;
    FGMtxtText: String;
    FGMtxtUserName: String;
    FGMtxtPassword: String;
    FGMtxtMemberId: String;
    FGMClientVersion: String;
    FGMClientSessionId: String;
    FGMtxtGenMapImage: String;
    FGMtxtZoom: String;
    FGMtxtLocLabel: String;
    FGMtxtRmTestList: String;
    FGMtxtMapHeight: String;
    FGMtxtMapWidth: String;

    FGMtxtLocPtX: String;
    FGMtxtLocPtY: String;
    FGMtxtImageID: String;
    FGMtxtImageURL: String;

    //variables for RequestSpotting
    FRSImageID: String;
    FRStxtLocPtX: String;
    FRStxtLocPtY: String;
    FRStxtZoom: String;
    FRStxtInteractiveMap: String;
    FRStxtUserName: String;
    FRStxtPassword: String;
    FRStxtMemberId: String;
    FRStxtMapWidth: String;
    FRStxtMapHeight: String;
    FRSClientSessionId: String;

    {additional required info used for our authentication & trasaction tracking}
    FGMCustomerId: String;
    FGMCustomerPin: String;
    FGMCustomerIP: String;

    //global configuration variables
    gSERVERIP: String;
    gUSERNAME: String;
    gPASSWORD: String;
    gSESSIONID: String;
    gCLIENTVERSION: String;
    gSERVERTOUSE: String;
    gCUSTDBCONNECTSTR: String;

    gSERVERUSED: integer;

    gPROD_SERVERIP: String;
    gPROD_USERNAME: String;
    gPROD_PASSWORD: String;
    gPROD_SESSIONID: String;
    gPROD_CLIENTVERSION: String;
    gPROD_SERVERTOUSE: String;
    gPROD_CUSTDBCONNECTSTR: String;


    gTEST_SERVERIP: String;
    gTEST_USERNAME: String;
    gTEST_PASSWORD: String;
    gTEST_SESSIONID: String;
    gTEST_CLIENTVERSION: String;
    gTEST_SERVERTOUSE: String;
    gTEST_CUSTDBCONNECTSTR: String;

    gDebugOn: boolean;

    VImageName: string;
    VImageURL: string;
    VLat: double;
    VLong: double;

    procedure SpecialHackfor240_CombineCommunityAndPanel(ResultNode: IXMLNode);
    function RemoveXMLChars(xmlStr: String; remChs: String): String;
    function ReformatCensusID(census: String): String;
    function URLEncode(const DecodedStr: String): String;
    function ParseResult(XMLStr: String): String;
    function httpGet(url: String): String;
    function httpGetStream(url: String):TMemoryStream;
  public
  { Public declarations }
    function GetInfo(): String;

    function GetMap(): String;
    function GetReSpottedMapInfo(): String; //added re-spotting, zooming
    function GetReSpottedMapImage(): Boolean; //added re-spotting, zooming


    function UserHasAccess(const custID, Code: String): string;
    function AddServiceUsage(iTransStatus: integer; iUsedFrom: integer): string;
    function ParseConfiguration(): boolean;
    procedure WriteToLogFile(ipMsgToWrite: String);
  published
  { Published declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property GItxtText: String read FGItxtText write FGItxtText;
    property GItxtStreet: String read FGItxtStreet write FGItxtStreet;
    property GItxtCity: String read FGItxtCity write FGItxtCity;
    property GItxtState: String read FGItxtState write FGItxtState;
    property GItxtZip: String read FGItxtZip write FGItxtZip;
    property GItxtPlus4: String read FGItxtPlus4 write FGItxtPlus4;
    property GItxtUserName: String read FGItxtUserName write FGItxtUserName;
    property GItxtPassword: String read FGItxtPassword write FGItxtPassword;
    property GItxtMemberId: String read FGItxtMemberId write FGItxtMemberId;
    property GIClientVersion: String read FGIClientVersion write FGIClientVersion;
    property GIClientSessionId: String read FGIClientSessionId write FGIClientSessionId;
    property GIMapHeight : String read FGIMapHeight write FGIMapHeight;
    property GIMapWidth: String read FGIMapWidth write FGIMapWidth;
    Property GIMapZoom: String read FGIMapZoom write FGIMapZoom;


    {additional required info used for our authentication & trasaction tracking}
    property GICustomerId: String read FGICustomerId write FGICustomerId;
    property GICustomerPin: String read FGICustomerPin write FGICustomerPin;
    property GICustomerIP: String read FGICustomerIP write FGICustomerIP;

    //variables for GetMap() function, variable prefix GM=GetMap
    property GMtxtStreet: String read FGMtxtStreet write FGMtxtStreet;
    property GMtxtCity: String read FGMtxtCity write FGMtxtCity;
    property GMtxtState: String read FGMtxtState write FGMtxtState;
    property GMtxtZip: String read FGMtxtZip write FGMtxtZip;
    property GMtxtPlus4: String read FGMtxtPlus4 write FGMtxtPlus4;
    property GMtxtLon: String read FGMtxtLon write FGMtxtLon;
    property GMtxtLat: String read FGMtxtLat write FGMtxtLat;
    property GMtxtGeoResult: String read FGMtxtGeoResult write FGMtxtGeoResult;
    property GMtxtCensusBlockId: String read FGMtxtCensusBlockId write FGMtxtCensusBlockId;
    property GMtxtText: String read FGMtxtText write FGMtxtText;
    property GMtxtUserName: String read FGMtxtUserName write FGMtxtUserName;
    property GMtxtPassword: String read FGMtxtPassword write FGMtxtPassword;
    property GMtxtMemberId: String read FGMtxtMemberId write FGMtxtMemberId;
    property GMClientVersion: String read FGMClientVersion write FGMClientVersion;
    property GMClientSessionId: String read FGMClientSessionId write FGMClientSessionId;
    property GMtxtGenMapImage: String read FGMtxtGenMapImage write FGMtxtGenMapImage;
    property GMtxtZoom: String read FGMtxtZoom write FGMtxtZoom;
    property GMtxtLocLabel: String read FGMtxtLocLabel write FGMtxtLocLabel;
    property GMtxtRmTestList: String read FGMtxtRmTestList write FGMtxtRmTestList;
    property GMtxtMapHeight: String read FGMtxtMapHeight write FGMtxtMapHeight;
    property GMtxtMapWidth: String read FGMtxtMapWidth write FGMtxtMapWidth;

    {additional required info used for our authentication & trasaction tracking}
    property GMCustomerId: String read FGMCustomerId write FGMCustomerId;
    property GMCustomerPin: String read FGMCustomerPin write FGMCustomerPin;
    property GMCustomerIP: String read FGMCustomerIP write FGMCustomerIP;

    property GMtxtLocPtX: String read FGMtxtLocPtX write FGMtxtLocPtX;
    property GMtxtLocPtY: String read FGMtxtLocPtY write FGMtxtLocPtY;
    property GMtxtImageID: String read FGMtxtImageID write FGMtxtImageID;
    property GMtxtImageURL: String read FGMtxtImageURL write FGMtxtImageURL;

    {properties for RequestSpotting}
    property RSImageID: String read FRSImageID write FRSImageID;
    property RStxtLocPtX: String read FRStxtLocPtX write FRStxtLocPtX;
    property RStxtLocPtY: String read FRStxtLocPtY write FRStxtLocPtY;
    property RStxtZoom: String read FRStxtZoom write FRStxtZoom;
    property RStxtInteractiveMap: String read FRStxtInteractiveMap write FRStxtInteractiveMap;
    property RStxtUserName: String read FRStxtUserName write FRStxtUserName;
    property RStxtPassword: String read FRStxtPassword write FRStxtPassword;
    property RStxtMemberId: String read FRStxtMemberId write FRStxtMemberId;
    property RStxtMapWidth: String read FRStxtMapWidth write FRStxtMapWidth;
    property RStxtMapHeight: String read FRStxtMapHeight write FRStxtMapHeight;
    property RSClientSessionId: String read FRSClientSessionId write FRSClientSessionId;

    property SERVICE_ID: Integer read FSERVICE_ID write FSERVICE_ID;
    property WSDL_LOCATION: String read FWSDL_LOCATION write FWSDL_LOCATION;
    property WS_PIN: String read FWS_PIN write FWS_PIN;
    property gUsageFlag: Boolean read FgUsageFlag write FgUsageFlag;
  protected
  { Protected declarations }
    //constructor Create(AOwner: TComponent); override;
    //destructor Destroy; override;
  end;

implementation

//uses WebReq;

constructor TFloodMap.Create(AOwner: TComponent);
begin
  inherited;
  //check if we could read the
end;

destructor TFloodMap.Destroy;
begin

  inherited;
end;

function TFloodMap.ParseResult(XMLStr: String): String;
var i,j,k: integer;
begin
  //<string xmlns="http://tempuri.org/">There are no messages for Location Map.</string>
  //<string xmlns="http://tempuri.org/">Success 2</string>

  i:= POS('<string xmlns="http://tempuri.org/">',XMLStr);
  j:= POS('</string>',XMLStr);
  k:= Length('<string xmlns="http://tempuri.org/">');
  //l:= Length('</string>');
  Result := Copy(XMLStr,i+k,(j-(i+k)));
end;

function TFloodMap.GetInfo(): String;
var
  //FidHTTP: TidHTTP;
  GeoCodeQueryStr: String;
  XMLStr: String;
  GeoCodeURL, ErrMsg: String;

  XMLDOM: IXMLDocument;
  CdGeoResultsNode: IXMLNode;
  CdCandidatesNode: IXMLNode;
  CdCandidateNode: IXMLNode;

  //local variables to hold the values of Candidate Nodes
  lvtxtStreet, lvtxtCity, lvtxtState, lvtxtZip, lvtxtPlus4, lvtxtLon,
  lvtxtLat, lvtxtGeoResult, lvtxtFirm, lvtxtCensusId, lvtxtPrecision: String;

  ErrorFlag: Boolean;

  ErrorPOS1, ErrorPOS2: Integer;
begin
  ErrorFlag := False;
  try
    try
      //instantiate the HTTP client to run HttpGet
      //FidHTTP := TidHTTP.Create(self);

      //these values are read from the configuration file and also influenced by
      //user authentication using the Subscription Server
      FGItxtUserName         := gUSERNAME;
      FGItxtPassword         := gPASSWORD;
      FGItxtMemberId         := '';
      FGIClientVersion       := gCLIENTVERSION;
      FGIClientSessionId     := gSESSIONID;

      GeoCodeURL := 'https://' + gSERVERIP + '/CdWsRmIIS/CdGeoCode.Asp';

      //build the HttpGet query string
      GeoCodeQueryStr :=
        'txtText='           + URLEncode(GItxtText)   + '&' +
        'txtStreet='         + URLEncode(GItxtStreet) + '&' +
        'txtCity='           + URLEncode(GItxtCity)   + '&' +
        'txtState='          + URLEncode(GItxtState)  + '&' +
        'txtZip='            + URLEncode(GItxtZip)    + '&' +
        'txtPlus4='          + URLEncode(GItxtPlus4)  + '&' +
        'txtUserName='       + GItxtUserName          + '&' +
        'txtPassword='       + GItxtPassword          + '&' +
        'ClientSessionId='   + GIClientSessionId;

      //run the HttpGet to get the XML result into XMLStr
      WriteToLogFile('Geocoding Call:');
      //WriteToLogFile(GeoCodeURL + '?' + GeoCodeQueryStr);

      //XMLStr := FidHTTP.Get(GeoCodeURL + '?' + GeoCodeQueryStr);
      xmlStr := httpGet(GeoCodeURL + '?' + GeoCodeQueryStr);
      //if nothing is returned, raise exception to be passed to user. This never happens
      //WriteToLogFile('Geocoding Return XML:');
      //WriteToLogFile(XMLStr);

      if length(XMLStr) = 0 then
      raise Exception.create('There were no results returned. The address may be incorrect.');

      //check for <CdErros> here
      ErrorPOS1 := Pos('<CdError>',XMLStr);
      ErrorPOS2 := Pos('<CdErrors>',XMLStr);

      if (ErrorPOS1 > 0) or (ErrorPOS2 > 0) then
      begin
        //copy the actual error code from the XML
        ErrorPOS1 := Max(ErrorPOS1,ErrorPOS2);

        //reuse POS2
        ErrorPOS2 := (POS('</CdErrors>',XMLStr) - ErrorPOS1) - 1;

        ErrMsg := Copy(XMLStr,ErrorPOS1, ErrorPOS2);

        //pass it over to user
        raise Exception.create('Flood Insight Server returned errors while geocoding this property address.' + #13 + #13 + ErrMsg);
      end;

      //check if the result XML contains multiple candidates
      XMLDOM := LoadXMLData(XMLStr);

      //read the top most CdGeoResults node
      CdGeoResultsNode := XMLDOM.ChildNodes.FindNode('CdGeoResults');
      if CdGeoResultsNode <> nil then
      begin
        //read CdCandidates
        CdCandidatesNode := CdGeoResultsNode.ChildNodes.FindNode('CdCandidates');
        if CdCandidatesNode <> nil then
        begin
          //check how many child nodes are there
          if CdCandidatesNode.ChildNodes.Count > 1 then
          begin
            //send the XML as it is to the client
            Result := XMLStr;
          end
          else
          begin
            //parse the XMLStr further and get the map
            CdCandidateNode := CdCandidatesNode.ChildNodes.FindNode('CdCandidate');
            if CdCandidateNode <> nil then
            begin
              lvtxtStreet     := CdCandidateNode.ChildNodes['txtStreet'].Text;
              lvtxtCity       := CdCandidateNode.ChildNodes['txtCity'].Text;
              lvtxtState      := CdCandidateNode.ChildNodes['txtState'].Text;
              lvtxtZip        := CdCandidateNode.ChildNodes['txtZip'].Text;
              lvtxtPlus4      := CdCandidateNode.ChildNodes['txtPlus4'].Text;
              lvtxtLon        := CdCandidateNode.ChildNodes['txtLon'].Text;
              lvtxtLat        := CdCandidateNode.ChildNodes['txtLat'].Text;
              lvtxtGeoResult  := CdCandidateNode.ChildNodes['txtGeoResult'].Text;
              lvtxtFirm       := CdCandidateNode.ChildNodes['txtFirm'].Text;
              lvtxtCensusId   := CdCandidateNode.ChildNodes['txtCensusBlockId'].Text;
              lvtxtPrecision  := CdCandidateNode.ChildNodes['txtPrecision'].Text;

              // assign variables for the Getmap() function
              GMtxtText             := GItxtText;
              GMtxtStreet           := lvtxtStreet;
              GMtxtCity             := lvtxtCity;
              GMtxtState            := lvtxtState;
              GMtxtZip              := lvtxtZip;
              GMtxtPlus4            := lvtxtPlus4;
              GMtxtLon              := lvtxtLon;
              GMtxtLat              := lvtxtLat;
              GMtxtGeoResult        := lvtxtGeoResult;
              GMtxtCensusBlockId    := lvtxtCensusId;
              GMtxtUserName         := GItxtUserName;
              GMtxtPassword         := GItxtPassword;
              GMtxtMemberId         := GItxtMemberId;
              GMClientVersion       := GIClientVersion;
              GMClientSessionId     := GIClientSessionId;

              //parameters for generating the map
              GMtxtGenMapImage      := 'True';
              GMtxtZoom             := GIMapZoom;
              GMtxtLocLabel         := 'Subject';
              GMtxtRmTestList       := 'Flood,True';
              GMtxtMapHeight        := GIMapHeight;
              GMtxtMapWidth         := GIMapWidth;

              GMCustomerId          := GICustomerId;
              GMCustomerPin         := GICustomerPin;
              GMCustomerIP          := GICustomerIP;

              Result := GetMap();
            end else ErrorFlag := True;
          end;
        end else ErrorFlag := True;
      end else ErrorFlag := True;

      if ErrorFlag then raise Exception.create('There were no results returned. The address may be incorrect.');
    except
       on E: Exception do
       begin
        WriteToLogFile('GetInfo Exception: ' + E.Message);
        raise Exception.create('Error: '+ E.Message);
       end;
    end;
  finally
   // FidHTTP.Free;
   // FidHTTP := nil;
  end;
end;

function TFloodMap.GetMap(): String;
const
  xmlLnCR = #13#10;
  defaultMapZoom = '1.5';
var
  //FidHTTP : TidHTTP;
  RiskMeterQueryStr,XMLStr: String;
  XMLDOM: IXMLDocument;

  CdRmResultNode: IXMLNode;
  MapNode, NewNode, LocNode: IXMLNode;

  RiskMeterURL,CensusID,ImageURL,MapData: String;
  FlagError : Boolean;

  ErrorPOS1, ErrorPOS2: integer;
  ErrMsg: string;
  strm: TMemoryStream;
  btArray: Array of Byte;
  ind: integer;
begin
  FlagError := False;
  mapData := '';
  //get the authentication information for Risk Meter serever
  FGMtxtUserName         := gUSERNAME;
  FGMtxtPassword         := gPASSWORD;
  FGMtxtMemberId         := '';
  FGMClientVersion       := gCLIENTVERSION;
  FGMClientSessionId     := gSESSIONID;

  //build the query string
  RiskMeterURL := 'https://' + gSERVERIP + '/CdWsRmIIS/CdRm.Asp';
  RiskMeterQueryStr :=
    //txtName
    'txtStreet='          + URLEncode(GMtxtStreet)        + '&' +
    'txtCity='            + URLEncode(GMtxtCity)          + '&' +
    'txtState='           + URLEncode(GMtxtState)         + '&' +
    'txtZip='             + URLEncode(GMtxtZip)           + '&' +
    'txtPlus4='           + URLEncode(GMtxtPlus4)         + '&' +
    //txtFirm
    'txtUserName='        + GMtxtUserName                 + '&' +
    'txtPassword='        + GMtxtPassword                 + '&' +
    'txtLon='             + GMtxtLon           + '&' +
    'txtLat='             + GMtxtLat           + '&' +
    'txtGeoResult='       + GMtxtGeoResult     + '&' +
    'txtCensusBlockId='   + GMtxtCensusBlockId + '&' +
    'txtRmTestList='      + 'Flood,True'                  + '&' +

    //optional
    'txtGenMapImage='     + 'TRUE'                        + '&' +
    //'txtZoom='            + GMtxtZoom          + '&' +
    'txtZoom='            + defaultMapZoom          + '&' +   //08/01/2013 YF At flightinsight site the default zoom is 2.0
                                                              //in the result map sometime came without street names
    'txtMapWidth='        + GMtxtMapWidth      + '&' +
    'txtMapHeight='       + GMtxtMapHeight     + '&' +
    'txtInteractiveMap='  + 'TRUE'                        + '&' +
    'ClientSessionId='    + GMClientSessionId             + '&' +
    'HideLocation='       + 'True'                       + '&' +

    //not listed in the latest doc
    'txtText='            + GMtxtText                     + '&' +
    'txtLocLabel='         + URLEncode('Subject')          ;
  try
    try
      //instantiate the HTTP client to run HttpGet for getting the map
      //FidHTTP := TidHTTP.Create(self);

      WriteToLogFile('GetMap Call:');
      //WriteToLogFile(RiskMeterURL + '?' +RiskMeterQueryStr);

      //run the HttpGet to get the XML result into XMLStr
      //XMLStr := FidHTTP.Get(RiskMeterURL + '?' +RiskMeterQueryStr);
      xmlStr := httpGet(RiskMeterURL + '?' +RiskMeterQueryStr);

      //WriteToLogFile('GetMap Result XML:');
      //WriteToLogFile(XMLStr);
      //if nothing is returned, raise exception to be passed to user. This never happens
      if length(XMLStr) = 0 then
        raise Exception.create('There were no results returned from the Map Query. The address may be incorrect.');

      //check for <CdErros> here
      ErrorPOS1 := Pos('<CdError>',XMLStr);
      ErrorPOS2 := Pos('<CdErrors>',XMLStr);

      if (ErrorPOS1 > 0) or (ErrorPOS2 > 0) then
      begin
        //copy the actual error code from the XML
        ErrorPOS1 := Max(ErrorPOS1,ErrorPOS2) + 10;

        ErrorPOS2 := (POS('</CdErrors>',XMLStr) - ErrorPOS1);

        ErrMsg := Copy(XMLStr,ErrorPOS1, ErrorPOS2);

        //pass it over to user
        raise Exception.create('Flood Insight returned errors while mapping this property address.' + #13 + #13 + ErrMsg);
      end;

//      if (Pos('<CdError>',XMLStr) > 0) or (Pos('<CdErrors>',XMLStr) > 0) then
//      raise Exception.create('Flood Insight Server returned errors while mapping this property address.');

      //check if the result XML contains multiple candidates
      XMLDOM := LoadXMLData(XMLStr);

      if XMLDOM.IsEmptyDoc then
        raise Exception.create('There were no results returned from the Map Query. The address may be incorrect.');

      CdRmResultNode := XMLDOM.ChildNodes.FindNode('CdRmResult');
      if CdRmResultNode <> nil then
      begin
        //add the longitude and latitude to XML
        LocNode := CdRmResultNode.ChildNodes.FindNode('Location');
        NewNode := LocNode.AddChild('Longitude');
        NewNode.Text := GMtxtLon;
        NewNode := LocNode.AddChild('Latitude');
        NewNode.Text := GMtxtLat;

        NewNode := LocNode.AddChild('GeocodeResult');
        NewNode.Text := GMtxtGeoResult;

        CensusID := LocNode.ChildNodes['CensusBlock'].Text;
        LocNode.ChildNodes['CensusBlock'].Text := ReformatCensusID(CensusID);

        SpecialHackfor240_CombineCommunityAndPanel(CdRmResultNode);

        XMLDOM.SaveToXML(XMLStr);
        XMLStr := RemoveXMLChars(XMLStr, xmlLnCR);

        MapNode := CdRmResultNode.ChildNodes.FindNode('Map');
        if MapNode <> nil then
        begin
          //get the map location from XML
          ImageURL := 'https://' + MapNode.ChildNodes.FindNode('ImageURL').NodeValue + '/' +
            MapNode.ChildNodes.FindNode('ImageName').NodeValue;

          //get the map
          WriteToLogFile('GetMapImage Call:');
          //WriteToLogFile('MapImageURL: ' + ImageUrl);
          //MapData := FidHTTP.Get(ImageURL);
          strm := httpGetStream(ImageURL);
          try
            //strm.SaveToFile('C:\WebServices\FloodServer\mapImage112818orig.jpg');
            setLength(btArray, strm.Size);
            strm.Position := 0;
            try
              setLength(btArray, strm.Size);
              strm.Read(btArray[0],length(btarray));
            finally
            if assigned(strm) then  strm.Free;
            end;
            setLength(mapData,length(btArray));
            for ind := 0 to length(mapData) - 1 do
              mapData[ind+1] := AnsiChar(btArray[ind]);
           finally
            setlength(btArray,0);
           end;
          //alert user if map is not there
          if length(MapData) = 0 then
            raise Exception.create('There was a problem creating the map. The address may be incorrect.');

          //log the transaction here with customer information
          //if not LogTheTrasaction(GMCustomerID, GMCustomerPin, 'FloodMap') then
          //  raise Exception.create('There was a problem performing this trsaction. Please contact customer support.');

          // Send back the entire XMLStr and the map binary data.
          Result := 'XMLData' + '=' + XMLStr + '&' + 'MapData' + '=' + MapData;

          //set the flag that that map was generated
          gUsageFlag := True;

        end else FlagError := True;
      end else FlagError := True;

      if FlagError then Exception.create('There was a problem creating the map. The address may be incorrect.');
    except
       on E: Exception do raise Exception.Create(E.message);
    end;
  finally
    //FidHTTP.Free;
    //FidHTTP := nil;
  end;
end;

function TFloodMap.ParseConfiguration(): boolean;
var
  CfgFile,SectionToRead: String;
  CfgIni: TIniFile;
  szFileName: array[0..MAX_PATH] of Char;
  DirStr : string;
begin
  Result := True;

  //get the DLL path where the ini file resides
  GetModuleFileName(hInstance, szFileName, MAX_PATH);
  DirStr := ExtractFilePath(szFileName);
  CfgFile := DirStr + 'FloodServer2.ini';

  //if the configuration file exists then read the default configurations
  Cfgini := nil;
  if FileExists(CfgFile) then
  begin
    try
      CfgIni := TIniFile.Create(CfgFile);

      gCUSTDBCONNECTSTR := CfgIni.ReadString('general', 'custDBConnString','Error');
      if gCUSTDBCONNECTSTR = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gSERVERTOUSE      := CfgIni.ReadString('general', 'serverToUse','Error');
      if gSERVERTOUSE = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      //added to read the production server variables
      SectionToRead :=  'productionsServer';
      gPROD_SERVERIP       := CfgIni.ReadString(SectionToRead, 'ipAddress','Error');
      if gPROD_SERVERIP = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gPROD_USERNAME       := CfgIni.ReadString(SectionToRead, 'uid','Error');
      if gPROD_USERNAME = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gPROD_PASSWORD       := CfgIni.ReadString(SectionToRead, 'pwd','Error');
      if gPROD_PASSWORD = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gPROD_SESSIONID      := CfgIni.ReadString(SectionToRead, 'sessionID','Error');
      if gPROD_SESSIONID = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gPROD_CLIENTVERSION  := CfgIni.ReadString(SectionToRead, 'clientVersion','Error');
      if gPROD_CLIENTVERSION = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      //added to read test server variables
      SectionToRead := 'testServer';
      gTEST_SERVERIP       := CfgIni.ReadString(SectionToRead, 'ipAddress','Error');
      if gSERVERIP = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gTEST_USERNAME       := CfgIni.ReadString(SectionToRead, 'uid','Error');
      if gUSERNAME = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gTEST_PASSWORD       := CfgIni.ReadString(SectionToRead, 'pwd','Error');
      if gPASSWORD = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gTEST_SESSIONID      := CfgIni.ReadString(SectionToRead, 'sessionID','Error');
      if gSESSIONID = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gTEST_CLIENTVERSION  := CfgIni.ReadString(SectionToRead, 'clientVersion','Error');
      if gCLIENTVERSION = 'Error' then
      begin
        Result := False;
        Exit;
      end;

      gDebugOn := CfgIni.ReadBool('debugOptions', 'debugOn',False);


      //now set the golobal variable to the one we want to use. test varibles
      // are used while dynamically switching the server per user request
      if UpperCase(gSERVERTOUSE) = 'TEST' then
      begin
        gSERVERIP         :=  gTEST_SERVERIP;
        gUSERNAME         :=  gTEST_USERNAME;
        gPASSWORD         :=  gTEST_PASSWORD;
        gSESSIONID        :=  gTEST_SESSIONID;
        gCLIENTVERSION    :=  gTEST_CLIENTVERSION;
        gSERVERTOUSE      :=  gTEST_SERVERTOUSE;
        gCUSTDBCONNECTSTR :=  gTEST_CUSTDBCONNECTSTR;
      end
      else if UpperCase(gSERVERTOUSE) = 'PRODUCTION' then
      begin
        gSERVERIP         :=  gPROD_SERVERIP;
        gUSERNAME         :=  gPROD_USERNAME;
        gPASSWORD         :=  gPROD_PASSWORD;
        gSESSIONID        :=  gPROD_SESSIONID;
        gCLIENTVERSION    :=  gPROD_CLIENTVERSION;
        gSERVERTOUSE      :=  gPROD_SERVERTOUSE;
        gCUSTDBCONNECTSTR :=  gPROD_CUSTDBCONNECTSTR;
      end
      else
      begin
        Result := False;
        Exit;
      end;

    finally
      if assigned(cfgini) then
        CfgIni.Free;
    end;
  end else Result := False;
end;

//encode the string to be used in URL
function TFloodMap.URLEncode(const DecodedStr: String): String;
var
  I: Integer;
begin
  Result := '';
  if Length(DecodedStr) > 0 then
  begin
    for I := 1 to Length(DecodedStr) do
    begin
      if not (DecodedStr[I] in ['0'..'9', 'a'..'z', 'A'..'Z', ' ']) then
        Result := Result + '%' + IntToHex(Ord(DecodedStr[I]), 2)
      else if not (DecodedStr[I] = ' ') then
        Result := Result + DecodedStr[I]
      else
      begin
        Result := Result + '+';
      end;
    end;
  end;
end;

function TFloodMap.ReformatCensusID(census: String): String;
begin
  result := Copy(census, 6, 6);
  insert('.', result, 5);
end;

function TFloodMap.RemoveXMLChars(xmlStr: String; remChs: String): String;
var
  remIdx, remLen: Integer;
begin
  result := xmlStr;
  remLen := length(remChs);
  remIdx := POS(remChs, result);
  if remIdx > 0 then
    Delete(result, remIdx, remLen);
end;

procedure TFloodMap.SpecialHackfor240_CombineCommunityAndPanel(ResultNode: IXMLNode);
var
  nNode:IXMLNode;
  FloodFeatureNode: IXMLNode;
  tCommunity, tPanel: String;
begin
  nNode := ResultNode.ChildNodes.FindNode('Tests');
  if assigned(nNode) then
  begin
    nNode := nNode.ChildNodes.FindNode('Flood');
    if assigned(nNode) then
    begin
      nNode := nNode.ChildNodes.FindNode('Features');
      if assigned(nNode) then
      begin
        FloodFeatureNode := nNode.ChildNodes.FindNode('Feature1');
        if assigned(FloodFeatureNode) then
        begin
          tCommunity := FloodFeatureNode.ChildNodes['Community'].Text;
          tPanel := FloodFeatureNode.ChildNodes['Panel'].Text;
          FloodFeatureNode.ChildNodes['Panel'].Text := tCommunity + ' ' + tPanel;
        end;
      end;
    end;
  end;
end;

function TFloodMap.UserHasAccess(const custID, Code: String): string;
var sRetMsg : string;
//var TempIDHTTP: TIDHTTP;
begin
  //check subscription service detail using new subscription server.
  try
    if (Length(CustID) > 0 ) and (Length(Code) > 0) {(compareText(Code, 'FREE') = 0)} then
    begin
         //call the subscription server to find out if user is authorize to use this service
         //and whether he has demo or paid units to use at this time
         try
           //TempIDHTTP := TIDHTTP.Create(Self);
           //AuthenticateCustomer?iCustID=string&sCustPin=string&iServiceID=string

           //sRetMsg := TempIDHTTP.Get(WSDL_LOCATION+'AuthenticateCustomer?iCustID='+ CustID + '&sCustPin='+ WS_PIN + '&iServiceID=' + IntToStr(SERVICE_ID));
           //WriteToLogFile(' Start UserHasAccess');
           sRetMsg := httpGet(WSDL_LOCATION+'AuthenticateCustomer?iCustID='+ CustID + '&sCustPin='+ WS_PIN + '&iServiceID=' + IntToStr(SERVICE_ID));

           sRetMsg := ParseResult(sRetMsg);


           if  not ((sRetMsg = 'Success 1') or (sRetMsg = 'Success 2'))  then
           begin
             Result := 'Error:' + sRetMsg;
             Exit;
           end;
         finally
           begin
             //TempIDHTTP.Free;
             //TempIDHTTP := nil;
           end;
         end;
        if (sRetMsg = 'Success 1') then   //paid units
        begin
          gSERVERIP         :=  gPROD_SERVERIP;
          gUSERNAME         :=  gPROD_USERNAME;
          gPASSWORD         :=  gPROD_PASSWORD;
          gSESSIONID        :=  gPROD_SESSIONID;
          gCLIENTVERSION    :=  gPROD_CLIENTVERSION;
          gSERVERTOUSE      :=  gPROD_SERVERTOUSE;
          gCUSTDBCONNECTSTR :=  gPROD_CUSTDBCONNECTSTR;

          gSERVERUSED       := 1;
          Result            := sRetMsg;
        end
        {else if (sRetMsg = 'Success 2') then  //demo units      we do not use demo units any more
        begin
          gSERVERIP         :=  gTEST_SERVERIP;
          gUSERNAME         :=  gTEST_USERNAME;
          gPASSWORD         :=  gTEST_PASSWORD;
          gSESSIONID        :=  gTEST_SESSIONID;
          gCLIENTVERSION    :=  gTEST_CLIENTVERSION;
          gSERVERTOUSE      :=  gTEST_SERVERTOUSE;
          gCUSTDBCONNECTSTR :=  gTEST_CUSTDBCONNECTSTR;

          gSERVERUSED       := 2;
          Result            := sRetMsg;
        end      }
        else
        begin
          Result := sRetMsg;
        end;
    end
    else Result := 'NOTICE: You are not presently recognized as a Flood Maps User.'+ #13 + #13
                  +'Please ensure you have purchased Flood Maps service and you have registered ClickFORMS. To register ClickFORMS click on the Registration option on the Help Menu. You will need your Customer Serial Number to register ClickFORMS.'+ #13 + #13
                  +'To purchase Flood Maps, please call Bradford Technologies Registration Department at 1-800-622-8727.';
  except
    on E: Exception do
    begin
      Result :=  'ERROR: '+ E.Message;
      WriteToLogFile('UserHasAccess Exception: ' + E.Message);
    end;
  end;
end;

function TFloodMap.AddServiceUsage(iTransStatus: integer; iUsedFrom: integer): string;
var //TempIDHTTP: TIDHttp;
sRetMsg: String;
sSearchCriteria: String;
begin
  //log the trasaction
  Result := 'Success';
  try
   //TempIDHTTP := TIDHTTP.Create(Self);

   //AddServiceUsage?iCustID=string&sIPAddress=string&iServiceID=string
   //&sPin=string&iServerUsed=string&sSearchCriteria=string&iTransStatus=string&iActualTransactions=string HTTP/1.1

   if iUsedFrom = 1 then //if called from GetInfo
   begin
     sSearchCriteria :=  FGItxtStreet + ', ' + FGItxtCity + ', ' + FGItxtState + ', ' + FGItxtZip + '-' + FGItxtPlus4;
     //sRetMsg := TempIDHTTP.Get(WSDL_LOCATION+'AddServiceUsage?iCustID='+ FGICustomerId + '&sIPAddress=' +  FGICustomerIP + '&iServiceID=' + IntToStr(SERVICE_ID)
     // + '&sPin='+ WS_PIN + '&iServerUsed=' + IntToStr(gSERVERUSED) + '&sSearchCriteria=' + URLEncode(sSearchCriteria) + '&iTransStatus='+IntToStr(iTransStatus) + '&iActualTransactions=1');
     WriteToLogFile('Start AddServiceUsage');
     sRetMsg := httpGet(WSDL_LOCATION+'AddServiceUsage?iCustID='+ FGICustomerId + '&sIPAddress=' +  FGICustomerIP + '&iServiceID=' + IntToStr(SERVICE_ID)
      + '&sPin='+ WS_PIN + '&iServerUsed=' + IntToStr(gSERVERUSED) + '&sSearchCriteria=' + URLEncode(sSearchCriteria) + '&iTransStatus='+IntToStr(iTransStatus) + '&iActualTransactions=1');
   end
   else //if called from GetMap
   begin
     sSearchCriteria :=  FGMtxtStreet + ', ' + FGMtxtCity + ', ' + FGMtxtState + ', ' + FGMtxtZip + '-' + FGMtxtPlus4;
     //sRetMsg := TempIDHTTP.Get(WSDL_LOCATION+'AddServiceUsage?iCustID='+ FGMCustomerId + '&sIPAddress=' +  FGMCustomerIP + '&iServiceID=' + IntToStr(SERVICE_ID)
     //+ '&sPin='+ WS_PIN + '&iServerUsed=' + IntToStr(gSERVERUSED) + '&sSearchCriteria=' + URLEncode(sSearchCriteria) + '&iTransStatus='+IntToStr(iTransStatus) + '&iActualTransactions=1');
     sRetMsg := httpGet(WSDL_LOCATION+'AddServiceUsage?iCustID='+ FGMCustomerId + '&sIPAddress=' +  FGMCustomerIP + '&iServiceID=' + IntToStr(SERVICE_ID)
     + '&sPin='+ WS_PIN + '&iServerUsed=' + IntToStr(gSERVERUSED) + '&sSearchCriteria=' + URLEncode(sSearchCriteria) + '&iTransStatus='+IntToStr(iTransStatus) + '&iActualTransactions=1');
   end;


   if ParseResult(sRetMsg) <> 'Success' then
   begin
     Result := 'Error:' + sRetMsg;
   end;
  finally
   begin
     //TempIDHTTP.Free;
     //TempIDHTTP := nil;
   end;
  end;
end;

//used for creating log file for debugging purposes
procedure TFloodMap.WriteToLogFile(ipMsgToWrite: String);
var
  szFileName: array[0..MAX_PATH] of Char;
  DirStr, S, DebugLogFile : string;
  F: TextFile;
begin
  //if the debug is turned on in configuration file
  if gDebugOn then
  begin
    //get the dll path and build the debug log file name
    GetModuleFileName(hInstance, szFileName, MAX_PATH);
    DirStr := ExtractFilePath(szFileName);
    S := FormatDateTime('"FloodServer2_Debug_"mmddyyyy', Now);
    DebugLogFile := DirStr + S + '.Txt';

    //if the debug file already exists then append into it otherwise create a
    //new file and write the log
    if FileExists(DebugLogFile) then
    begin
      AssignFile(F, DebugLogFile);
      Append(F);
      if ipMsgToWrite = '<HR>' then
         Writeln(F, '--------------------------------------------------------------------------------')
      else
         Writeln(F, DateTimeToStr(Now)+ ': ' + ipMsgToWrite);
      CloseFile(F);
    end
    else
    begin
      AssignFile(F, DebugLogFile);
      Rewrite(F);
      if ipMsgToWrite = '<HR>' then
         Writeln(F, '--------------------------------------------------------------------------------')
      else
         Writeln(F, DateTimeToStr(Now)+ ': ' + ipMsgToWrite);
      CloseFile(F);
    end;
  end;
end;

function TFloodMap.GetReSpottedMapInfo(): String; //added re-spotting, zooming
const
  xmlLnCR = #13#10;
var
  //FidHTTP : TidHTTP;
  RiskMeterQueryStr,XMLStr: String;
  XMLDOM: IXMLDocument;

  CdRmResultNode: IXMLNode;
  NewNode, LocNode: IXMLNode;

  RiskMeterURL,CensusID,ImageURL,MapData: String;
  FlagError : Boolean;

  ErrorPOS1, ErrorPOS2: integer;
  ErrMsg: string;
begin
  FlagError := False;

  //get the authentication information for Risk Meter serever
  FGMtxtUserName         := gUSERNAME;
  FGMtxtPassword         := gPASSWORD;
  FGMClientSessionId     := gSESSIONID;

  //we need to first get the respottd map
  if not GetReSpottedMapImage() then
    raise Exception.create('There were errors respotting the map. The map might have expired.');


  //build the query string
  RiskMeterURL := 'https://' + gSERVERIP + '/CdWsRmIIS/CdRm.Asp';
  RiskMeterQueryStr :=
    //txtName
    'txtStreet='          + URLEncode(GMtxtStreet)        + '&' +
    'txtCity='            + URLEncode(GMtxtCity)          + '&' +
    'txtState='           + URLEncode(GMtxtState)         + '&' +
    'txtZip='             + URLEncode(GMtxtZip)           + '&' +
    'txtPlus4='           + URLEncode(GMtxtPlus4)         + '&' +
    //txtFirm
    'txtUserName='        + GMtxtUserName                 + '&' +
    'txtPassword='        + GMtxtPassword                 + '&' +

    //these two needs to be the new lat long that we received as result of respotting call.

    'txtLon='             + FloatToStr(vLong) + '&' +
    'txtLat='             + FloatToStr(vLat)  + '&' +

    'txtGeoResult='       + 'SPOTTED'                     + '&' +  //identifies re-spotting of previous call
    'txtCensusBlockId='   + URLEncode(GMtxtCensusBlockId) + '&' +
    'txtRmTestList='      + 'Flood,True'                  + '&' +

    'HideLocation='       + 'True'                       + '&' +
    //optional
    'txtGenMapImage='     + 'TRUE'                        + '&' +
    //'txtZoom='            + GMtxtZoom          + '&' +
    'txtMapWidth='        + GMtxtMapWidth      + '&' +
    'txtMapHeight='       + GMtxtMapHeight     + '&' +
    'txtInteractiveMap='  + 'TRUE'                        + '&' +
    'ClientSessionId='    + GMClientSessionId;

  try
    try
      //instantiate the HTTP client to run HttpGet for getting the map
      //FidHTTP := TidHTTP.Create(self);

      WriteToLogFile('Get Respotted Map Info call:');
      //WriteToLogFile(RiskMeterURL + '?' +RiskMeterQueryStr);

      //run the HttpGet to get the XML result into XMLStr
      //XMLStr := FidHTTP.Get(RiskMeterURL + '?' +RiskMeterQueryStr);
      xmlStr  := httpGet(RiskMeterURL + '?' +RiskMeterQueryStr);

     // WriteToLogFile('Get Respotted Map Info call Result XML:');
     // WriteToLogFile(XmlStr);

      //if nothing is returned, raise exception to be passed to user. This never happens
      if length(XMLStr) = 0 then
        raise Exception.create('There were no results returned from the Map Query. The address may be incorrect.');

      //check for <CdErros> here
      ErrorPOS1 := Pos('<CdError>',XMLStr);
      ErrorPOS2 := Pos('<CdErrors>',XMLStr);

      if (ErrorPOS1 > 0) or (ErrorPOS2 > 0) then
      begin
        //copy the actual error code from the XML
        ErrorPOS1 := Max(ErrorPOS1,ErrorPOS2) + 10;

        ErrorPOS2 := (POS('</CdErrors>',XMLStr) - ErrorPOS1);

        ErrMsg := Copy(XMLStr,ErrorPOS1, ErrorPOS2);

        //pass it over to user
        raise Exception.create('Flood Insight returned errors while mapping this property address.' + #13 + #13 + ErrMsg);
      end;

//      if (Pos('<CdError>',XMLStr) > 0) or (Pos('<CdErrors>',XMLStr) > 0) then
//      raise Exception.create('Flood Insight Server returned errors while mapping this property address.');

      //check if the result XML contains multiple candidates
      XMLDOM := LoadXMLData(XMLStr);

      if XMLDOM.IsEmptyDoc then
        raise Exception.create('There were no results returned from the Map Query. The address may be incorrect.');

      CdRmResultNode := XMLDOM.ChildNodes.FindNode('CdRmResult');
      if CdRmResultNode <> nil then
      begin
        //add the longitude and latitude to XML
        LocNode := CdRmResultNode.ChildNodes.FindNode('Location');
        NewNode := LocNode.AddChild('Longitude');
        NewNode.Text := FloatToStr(vLong);
        NewNode := LocNode.AddChild('Latitude');
        NewNode.Text := FloatToStr(vLat);

        NewNode := LocNode.AddChild('GeocodeResult');
        NewNode.Text := GMtxtGeoResult;

        CensusID := LocNode.ChildNodes['CensusBlock'].Text;
        LocNode.ChildNodes['CensusBlock'].Text := CensusID;//ReformatCensusID(CensusID);

        SpecialHackfor240_CombineCommunityAndPanel(CdRmResultNode);

        XMLDOM.SaveToXML(XMLStr);
        XMLStr := RemoveXMLChars(XMLStr, xmlLnCR);

        //get the map location from XML
        if ((Length(VImageURL) =0) or (length(VImageName) = 0)) then
        begin
          raise Exception.create('There was a problem creating the map. Respotted Map Information not found.');
        end;

        ImageURL := 'https://' + VImageURL + '/' + VImageName;

        //get the map
        //MapData := FidHTTP.Get(ImageURL);
        WriteToLogFile('Get Respoted mapImage');
        mapData  := httpGet(imageUrl);

        //alert user if map is not there
        if length(MapData) = 0 then
          raise Exception.create('There was a problem creating the map. The address may be incorrect.');

        //log the transaction here with customer information
        //if not LogTheTrasaction(GMCustomerID, GMCustomerPin, 'FloodMap') then
        //  raise Exception.create('There was a problem performing this trsaction. Please contact customer support.');

        // Send back the entire XMLStr and the map binary data.
        Result := 'XMLData' + '=' + XMLStr + '&' + 'MapData' + '=' + MapData;

        //set the flag that that map was generated
        //gUsageFlag := True;
      end;
      if FlagError then Exception.create('There was a problem creating the map. The address may be incorrect.');
    except
       on E: Exception do raise Exception.Create(E.message);
    end;
  finally
    //FidHTTP.Free;
    //FidHTTP := nil;
  end;
end;

function TFloodMap.GetReSpottedMapImage(): boolean; //added re-spotting, zooming
const
  xmlLnCR = #13#10;
var
 // FidHTTP : TidHTTP;
  CdMapURL, CdMapQueryStr,XMLStr: String;
  XMLDOM: IXMLDocument;
  ErrorPOS1, ErrorPOS2: integer;
  ErrMsg: string;
  MapNode, CdRmResultNode: IXMLNode;
begin
  Result := True;
  //get the authentication information for Risk Meter serever
  FGMtxtUserName         := gUSERNAME;
  FGMtxtPassword         := gPASSWORD;
  FGMClientSessionId     := gSESSIONID;

  //build the query string
  CdMapURL := 'https://' + Trim(GMtxtImageURL) + '/CdWsRmIIS/CdMap.Asp';
  CdMapQueryStr :=
    //txtName
    'ImageID='            + GMtxtImageID       + '&' +
    'txtLocPtX='          + GMtxtLocPtX        + '&' +
    'txtLocPtY='          + GMtxtLocPtY        + '&' +
    //'txtZoom='            + GMtxtZoom          + '&' +
    'txtInteractiveMap='  + 'TRUE'                        + '&' +
    //txtFirm
    'txtUserName='        + GMtxtUserName      + '&' +
    'txtPassword='        + GMtxtPassword      + '&' +

    'HideLocation='       + 'True'                       + '&' +
    //optional
    'txtMapWidth='        + GMtxtMapWidth      + '&' +
    'txtMapHeight='       + GMtxtMapHeight     + '&' +
    'ClientSessionId='    + GMClientSessionId;
  try
    try
      //instantiate the HTTP client to run HttpGet for getting the map
      //FidHTTP := TidHTTP.Create(self);
      WriteToLogFile('Get Respotted Map call:');
      //WriteToLogFile(CdMapURL + '?' +CdMapQueryStr);
      //run the HttpGet to get the XML result into XMLStr
      //XMLStr := FidHTTP.Get(CdMapURL + '?' +CdMapQueryStr);
      xmlStr := httpGet(CdMapURL + '?' +CdMapQueryStr);
      //WriteToLogFile('Get Respotted Map XML Result:');
      //WriteToLogFile(XMLStr);

      //if nothing is returned, raise exception to be passed to user. This never happens
      if length(XMLStr) = 0 then
      begin
        Result := false;
        Exit;
      end;

      //check for <CdErros> here
      ErrorPOS1 := Pos('<CdError>',XMLStr);
      ErrorPOS2 := Pos('<CdErrors>',XMLStr);

      if (ErrorPOS1 > 0) or (ErrorPOS2 > 0) then
      begin
        //copy the actual error code from the XML
        ErrorPOS1 := Max(ErrorPOS1,ErrorPOS2) + 10;

        ErrorPOS2 := (POS('</CdErrors>',XMLStr) - ErrorPOS1);

        ErrMsg := Copy(XMLStr,ErrorPOS1, ErrorPOS2);

        //pass it over to user
        Result := False;
        Exit;
      end;

      //just load the xml to check if its valid, if empty or invalid throw exception
      XMLDOM := LoadXMLData(XMLStr);
      if XMLDOM.IsEmptyDoc then
      begin
        Result := False;
        Exit;
      end
      else
      begin
        CdRmResultNode := XMLDOM.ChildNodes.FindNode('CdRmResult');
        if CdRmResultNode <> nil then
        begin
          MapNode := CdRmResultNode.ChildNodes.FindNode('Map');
          if MapNode <> nil then
          begin
            VImageName  := MapNode.ChildNodes.FindNode('ImageName').NodeValue;
            VImageURL := MapNode.ChildNodes.FindNode('ImageURL').NodeValue;
            VLong      := StrToFloat(MapNode.ChildNodes.FindNode('LocPtX').NodeValue);
            VLat     := StrToFloat(MapNode.ChildNodes.FindNode('LocPtY').NodeValue);
          end
          else Result := False;
        end else result := False;
      end;

    except
       Result := False;
    end;
  finally
    //FidHTTP.Free;
    //FidHTTP := nil;
  end;
end;

function TFloodMap.httpGet(url: String): String;
const
  httpRespOk = 200;
var
  httpRequest: IWinHttpRequest;
begin
  result := '';
  httpRequest := CoWinHTTPRequest.Create;
  with httpRequest do
    begin
      Open('GET', url, false);
      SetTimeouts(30000, 30000, 30000, 30000);
      WriteToLogFile('httpGetUrl: ' + url);
      send('');          //exception will be catch in the calling function
      if status <> httpRespOk then
         raise Exception.create('The server: ' + url + 'returns error code ' + intToStr(status));
      result := ResponseText;
      WriteToLogFile('result: ' + result)
    end;
end;

function TFloodMap.httpGetStream(url: String):TMemoryStream;
const
  httpRespOk = 200;
var
  httpRequest: IWinHttpRequest;
  OleStream: TOleStream;
begin
  httpRequest := CoWinHTTPRequest.Create;
  result := TMemoryStream.Create;
  with httpRequest do
    begin
      Open('GET', url, false);
      SetTimeouts(30000, 30000, 30000, 30000);
      WriteToLogFile('httpGetUrl: ' + url);
      send('');          //exception will be catch in the calling function
      if status <> httpRespOk then
         raise Exception.create('The server: ' + url + 'returns error code ' + intToStr(status));
    end;
  oleStream := TOleStream.Create(IUnknown(httpRequest.ResponseStream) as IStream);
  try
    oleStream.Position := 0;
    result.CopyFrom(OleStream, Olestream.Size);
    //result.SaveToFile('C:\WebServices\FloodServer\mapImage.jpg');
  finally
    olestream.Free;
  end;
end;

end.
