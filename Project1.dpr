program Project1;



uses
  Vcl.Forms,
  DataBaseHelper in 'DataBaseHelper.pas',
  ZlecenieEtap in 'ZlecenieEtap.pas',
  Harmonogramator in 'Harmonogramator.pas',
  MainWindow in 'MainWindow.pas' {Form1},
  QueryHelper in 'QueryHelper.pas',
  Stanowiska in 'Stanowiska.pas',
  Stanowisko in 'Stanowisko.pas',
  Zlecenia in 'Zlecenia.pas',
  Zlecenie in 'Zlecenie.pas',
  ZlecenieDane in 'ZlecenieDane.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
