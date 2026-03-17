with Raylib;
with Raylib.GUI;
with Ada.Text_IO;  use Ada.Text_IO;
with Interfaces.C; use Interfaces.C;

package body Trader_Core is
   package RL renames Raylib;
   package GUI renames Raylib.GUI;

   procedure Render_Trader is
      Terminal_Bounds : RL.Rectangle :=
        (x => 50.0, y => 100.0, width => 400.0, height => 300.0);
      Terminal_Active : Boolean := False;

      Scroll : aliased RL.Vector2 := (x => 0.0, y => 0.0);
      View   : aliased RL.Rectangle := (0.0, 0.0, 0.0, 0.0);

      Simulator_Bounds : constant RL.Rectangle :=
        (x => 500.0, y => 100.0, width => 200.0, height => 300.0);
      Simulator_Active : Boolean := False;

      Dragging       : Boolean := False;
      Last_Mouse_Pos : RL.Vector2 := (0.0, 0.0);
   begin
      RL.InitWindow
        (width => 800, height => 600, title => "Trader Terminal & Simulator");
      --  RL.SetTargetFPS (30);
      GUI.GuiSetStyle
        (control  => GUI.DEFAULT,
         property => GUI.BACKGROUND_COLOR,
         value    => 16#20232A#); -- Dark background

      while not RL.WindowShouldClose loop
         RL.BeginDrawing;
         RL.ClearBackground (RL.BLACK);

         --  Draw Terminal Window
         if Terminal_Active then

            declare
               Content    : constant RL.Rectangle :=
                 (x => 0.0, y => 0.0, width => 400.0, height => 600.0);
               Scroll_Res : Interfaces.C.int;

            begin
               Scroll_Res :=
                 GUI.GuiScrollPanel
                   (bounds  => Terminal_Bounds,
                    text    => "Scrollable Terminal",
                    content => Content,
                    scroll  => Scroll'Access,
                    view    => View'Access);

               -- Make the terminal window moveable with the mouse
               if RL.IsMouseButtonDown (RL.MOUSE_BUTTON_LEFT) then
                  declare
                     Mouse_Pos : constant RL.Vector2 := RL.GetMousePosition;

                  begin
                     if Mouse_Pos.x >= Terminal_Bounds.x
                       and
                         Mouse_Pos.x
                         <= Terminal_Bounds.x + Terminal_Bounds.width
                       and Mouse_Pos.y >= Terminal_Bounds.y
                       and
                         Mouse_Pos.y
                         <= Terminal_Bounds.y + 30.0 -- title bar height
                     then
                        -- Drag the window
                        if not Dragging then
                           Dragging := True;
                           Last_Mouse_Pos := Mouse_Pos;
                        end if;
                     end if;

                     if Dragging then
                        declare
                           Dx : constant C_float :=
                             Mouse_Pos.x - Last_Mouse_Pos.x;
                           Dy : constant C_float :=
                             Mouse_Pos.y - Last_Mouse_Pos.y;
                        begin
                           Terminal_Bounds.x := Terminal_Bounds.x + Dx;
                           Terminal_Bounds.y := Terminal_Bounds.y + Dy;
                           Last_Mouse_Pos := Mouse_Pos;
                        end;
                     end if;
                  end;
               else
                  Dragging := False;
               end if;

               if GUI.GuiButton
                    (bounds =>
                       (x      =>
                          Terminal_Bounds.x + Terminal_Bounds.width - 22.0,
                        y      => Terminal_Bounds.y + 2.0,
                        width  => 20.0,
                        height => 20.0),
                     text   => "x")
                 /= 0
               then
                  Terminal_Active := False;
               end if;

               --  Draw content inside the scroll panel
               declare
                  type Vector2_Array is
                    array (Positive range <>) of aliased RL.Vector2;
                  Points : Vector2_Array :=
                    (1 =>
                       (x => Terminal_Bounds.x + 20.0 + Scroll.x,
                        y => Terminal_Bounds.y + 50.0 + Scroll.y),
                     2 =>
                       (x => Terminal_Bounds.x + 100.0 + Scroll.x,
                        y => Terminal_Bounds.y + 80.0 + Scroll.y),
                     3 =>
                       (x => Terminal_Bounds.x + 200.0 + Scroll.x,
                        y => Terminal_Bounds.y + 60.0 + Scroll.y),
                     4 =>
                       (x => Terminal_Bounds.x + 300.0 + Scroll.x,
                        y => Terminal_Bounds.y + 120.0 + Scroll.y));
               begin
                  RL.BeginScissorMode
                    (x      => Interfaces.C.int (View.x),
                     y      => Interfaces.C.int (View.y),
                     width  => Interfaces.C.int (View.width),
                     height => Interfaces.C.int (View.height));
                  RL.DrawSplineLinear
                    (points     => Points (1)'Unchecked_Access,
                     pointCount => Points'Length,
                     thick      => 3.0,
                     color_p    => RL.GREEN);
                  RL.EndScissorMode;
               end;
            end;
         end if;

         --  Draw Simulator Window
         if Simulator_Active then
            if GUI.GuiWindowBox
                 (bounds => Simulator_Bounds, title => "Trade Simulator")
              /= 0
            then
               Simulator_Active := False;
            end if;
         end if;

         --  Draw Toolbar
         if GUI.GuiButton
              (bounds =>
                 RL.Rectangle'
                   (x => 10.0, y => 10.0, width => 100.0, height => 30.0),
               text   => "Launch Terminal")
           /= 0
         then
            Put_Line ("Toolbar Button Clicked!");
            Terminal_Active := True;
         end if;

         if GUI.GuiButton
              (bounds =>
                 RL.Rectangle'
                   (x => 10.0, y => 50.0, width => 100.0, height => 30.0),
               text   => "Simulate Trade")
           /= 0
         then
            Put_Line ("Simulate Trade Button Clicked!");
            Simulator_Active := True;
         end if;

         RL.EndDrawing;
      end loop;

      RL.CloseWindow;
   end Render_Trader;
end Trader_Core;
