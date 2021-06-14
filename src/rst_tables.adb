-- A simple program to generate tables for restructured text.
-- Expected usage is:
-- rst_tables num_cols col_width num_row row_width

with Ada.Command_Line;
with Ada.Text_IO;
with GNAT.OS_Lib;

procedure Rst_Tables is
    package ACL renames Ada.Command_Line;
    package AIO renames Ada.Text_IO;

    Expected_Argument_Count : constant := 4;
    Num_Rows, Num_Cols, Row_Height, Col_Width : Integer;

    procedure Print_Usage is
    begin
        AIO.New_Line;
        AIO.Put_Line ("Usage: rst_tables "
                          & "num_cols col_width num_rows row_width");
        AIO.New_Line;
    end Print_Usage;

    procedure Die (Message : String) is
    begin
        AIO.Put_Line ("ERROR: " & Message);
        Print_Usage;
        GNAT.OS_Lib.OS_Exit (1);
    end Die;

    procedure Print_Divider (Cols, Width : Integer; Edge, Inner : Character) is
    begin
        AIO.Put(Edge);
        for C in 1 .. Cols loop
            for Tick in 1 .. Width loop
                AIO.Put(Inner);
            end loop;
            AIO.Put(Edge);
        end loop;
        AIO.New_Line;
    end Print_Divider;
begin
    if ACL.Argument_Count /= Expected_Argument_Count then
        Die ("Expected" & Expected_Argument_Count'Image
             & " arguments, but found " & ACL.Argument_Count'Image);
    end if;

    Num_Cols := Integer'Value(ACL.Argument(1));
    Col_Width := Integer'Value(ACL.Argument(2));
    Num_Rows := Integer'Value(ACL.Argument(3));
    Row_Height := Integer'Value(ACL.Argument(4));

    -- Print across all cols and then go down for each row.
    -- Tables look like this:
    -- +---+---+---+---+---+---+
    -- |   |   |   |   |   |   |
    -- |   |   |   |   |   |   |
    -- +---+---+---+---+---+---+
    -- |   |   |   |   |   |   |
    -- |   |   |   |   |   |   |
    -- +---+---+---+---+---+---+
    -- 1234567890123456789012345

    -- Prints a first header row.
    Print_Divider (Num_Cols, Col_Width, '+', '-');

    for R in 1 .. Num_Rows loop
        for Height in 1 .. Row_Height loop
            Print_Divider (Num_Cols, Col_Width, '|', ' ');
        end loop;
        Print_Divider (Num_Cols, Col_Width, '+', '-');
    end loop;
end Rst_Tables;
