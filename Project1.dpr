program Project1;

{$R 'C:\Program Files (x86)\Steema Software\TeeChart 2012 for RAD XE3\Examples\Features C++\Gantt_MouseDrag.dfm' :TForm(Gantt_MouseDrag)}

uses
  Vcl.Forms,
  MainWindow in 'MainWindow.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
