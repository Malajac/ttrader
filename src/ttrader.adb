with Raylib; use Raylib;
with Ada.Text_IO; use Ada.Text_IO;
 
procedure Ttrader is
begin
   InitWindow (width => 800, height => 600, title => "Trader Terminal & Simulator");

   loop
      BeginDrawing;
      ClearBackground (RAYWHITE);
      DrawText (text => "Hello Raylib from Ada!", posX => 190, posY => 200, fontSize => 20, color_p => LIGHTGRAY);
      EndDrawing;

      exit when WindowShouldClose;
   end loop;

   CloseWindow;
end Ttrader;
