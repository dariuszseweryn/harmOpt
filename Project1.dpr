program Project1;



uses
  Vcl.Forms,
  MainWindow in 'MainWindow.pas' {Form1},
  DataBaseHelper in 'DataBaseHelper.pas',
  EtapZlecenia in 'EtapZlecenia.pas',
  QueryHelper in 'QueryHelper.pas',
  EtapyZlecen in 'EtapyZlecen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
