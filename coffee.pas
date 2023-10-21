unit coffee;

interface

uses
  SysUtils, Classes, StrUtils;

function sukces(txt: string): boolean;
function nrtoken(txt: string): string;
function nrid(txt: string; pocz : integer): string;
function kreski(txt: string): integer;
function usrname(txt: string): string;
function accid(txt: string): string;  // account id

implementation

function usrname(txt: string): string;
var
  i:integer;
  szuk : string;
begin

result := '';
i:=PosEx('username":"',txt)+11;
  repeat
  result := result + txt[i];
  i := i+1;
  until txt[i] = '"' ;

end;

function accid(txt: string): string;
var
  i:integer;
  szuk : string;
begin

result := '';
i:=PosEx('account_id":',txt)+12;
  repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='}';

end;

function sukces(txt: string): boolean;
begin

result := false;
if PosEx( 'success', txt)<>0 then result := true;

end;

function nrtoken(txt: string): string;
var
  i:integer;
begin

result:='';
i:=PosEx('token":"',txt)+8;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='"';

end;

function kreski(txt: string): integer;
var
  i:integer;
begin

result := 0;
for i:=0 to length ( txt)  do
  if txt[i] = '/' then result := result + 1;

end;

function nrid(txt: string; pocz : integer): string;
var
  i:integer;
  szuk : string;
begin

result:='';
i:=pocz;
repeat
  result:=result+txt[i];
  i:=i+1
  until txt[i]='/';

end;

end.
