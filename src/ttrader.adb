with Raylib;
with Raylib.GUI;
with Ada.Text_IO; use Ada.Text_IO;
with Interfaces.C; use Interfaces.C;

procedure Ttrader is
   package RL renames Raylib;
   package GUI renames Raylib.GUI;

   Terminal_Bounds : constant RL.Rectangle := (x => 50.0, y => 100.0, width => 400.0, height => 300.0);
   Terminal_Active : Boolean := False;

   Simulator_Bounds : constant RL.Rectangle := (x => 500.0, y => 100.0, width => 200.0, height => 300.0);
   Simulator_Active : Boolean := False;
begin
   RL.InitWindow (width => 800, height => 600, title => "Trader Terminal & Simulator");

   GUI.GuiSetStyle (control => GUI.DEFAULT, property => GUI.BACKGROUND_COLOR, value => 16#20232A#); -- Dark background

   while not RL.WindowShouldClose loop
      RL.BeginDrawing;
      RL.ClearBackground (RL.BLACK);
      RL.DrawText (text => "Hello Raylib from Ada!", posX => 250, posY => 25, fontSize => 20, color_p => RL.RAYWHITE);

      if Terminal_Active then
         if GUI.GuiWindowBox (bounds => Terminal_Bounds, title => "Trader Terminal") /= 0 then
            Terminal_Active := False;
         end if;
      end if;

      if Simulator_Active then
         if GUI.GuiWindowBox (bounds => Simulator_Bounds, title => "Trade Simulator") /= 0 then
            Simulator_Active := False;
         end if;
      end if;

      --  Draw Toolbar
      if GUI.GuiButton (bounds => RL.Rectangle'(x => 10.0, y => 10.0, width => 100.0, height => 30.0), text => "Launch Terminal") /= 0 then
         Put_Line ("Toolbar Button Clicked!");
         Terminal_Active := True;
      end if;

      if GUI.GuiButton (bounds => RL.Rectangle'(x => 10.0, y => 50.0, width => 100.0, height => 30.0), text => "Simulate Trade") /= 0 then
         Put_Line ("Simulate Trade Button Clicked!");
         Simulator_Active := True;
      end if;

      RL.EndDrawing;
   end loop;

   RL.CloseWindow;
end Ttrader;
