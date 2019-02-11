library FloodServer3;

uses
  ActiveX,
  ComObj,
  WebBroker,
  ISAPIApp,
  ISAPIThreadPool,
  UWebFloodInsight in 'UWebFloodInsight.pas' {WebFloodInsights: TWebModule},
  uFloodMap in 'uFloodMap.pas',
  WinHttp_TLB in 'WinHttp_TLB.pas';

{$R *.RES}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.CreateForm(TWebFloodInsights, WebFloodInsights);
  Application.Run;
end.
