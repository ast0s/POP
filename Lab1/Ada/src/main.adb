with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   value_num_threads : Integer := 4;
   value_step : Long_Long_Integer := 2;

   type canStop_array is array (1.. value_num_threads) of Boolean;
   type delaySetter_array is array (1.. value_num_threads) of Duration;

   is_stop_array : canStop_array := (others => False);
   breaker_delay_set : delaySetter_array := (15.0, 15.5, 16.0, 16.5);

   pragma Atomic(is_stop_array);

   task type break_thread is
      entry SetDelay (delayTime : Duration; arrayPos : Integer);
   end break_thread;
   task type main_thread is
      entry SetPos(arrayPos: Integer; step : Long_Long_Integer);
   end main_thread;

   task body break_thread is
      timer : Duration;
      currentPos : Integer;
   begin
      accept SetDelay (delayTime : in Duration; arrayPos : in Integer) do
         timer := delayTime;
         currentPos := arrayPos;
      end SetDelay;
      delay (timer);
      is_stop_array(currentPos) := true;
   end break_thread;

   task body main_thread is
      step : Long_Long_Integer;
      sum : Long_Long_Integer := 0;
      currentPos : Integer;
   begin
      accept SetPos (arrayPos: in Integer; step: in Long_Long_Integer) do
         main_thread.step := step;
         currentPos := arrayPos;
      end SetPos;
      loop
         sum := sum + step;
         exit when is_stop_array(currentPos) = True;
      end loop;
      Put_Line("Id:" & currentPos'Img & " Sum:" & sum'Img & " Step:" & step'Img
               & " Delay Time (sec):" & breaker_delay_set(currentPos)'Img);
   end main_thread;

begin
   Put_Line("Thread amount:" & value_num_threads'Img);
   Put_Line("Step for count:" & value_step'Img);
   declare
      type main_thread_array is array(1.. value_num_threads) of main_thread;
      type break_thread_array is array (1.. value_num_threads) of break_thread;
      breaker: break_thread_array;
      main_threads : main_thread_array;
   begin
      for i in breaker'Range loop
         main_threads(i).SetPos(i, value_step);
         breaker(i).SetDelay(breaker_delay_set(i), i);
      end loop;
   end;
   null;
end Main;
