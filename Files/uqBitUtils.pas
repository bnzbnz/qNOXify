unit uqBitUtils;

interface

function IIF(Condition: Boolean; IsTrue, IsFalse: variant): variant;

implementation

function IIF(Condition: Boolean; IsTrue, IsFalse: variant): variant;
begin
  if Condition then
    Result := IsTrue
  else
    Result := IsFalse;
end;

end.
