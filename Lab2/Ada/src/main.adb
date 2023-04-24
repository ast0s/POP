with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

procedure main is
   array_length : constant integer := 100001;
   thread_count : constant integer := 4;
   arr : array(0..array_length) of integer;

   type randRange is new Integer range 1..array_length;
   package Rand_Int is new ada.numerics.discrete_random(randRange);use Rand_Int;
   gen : Generator;
   num : randRange;


   procedure Init_Arr is
      negative_index: integer := 1;
   begin
      reset(gen);
      for i in 0..array_length loop
         num := random(gen);
         arr(i) := integer(num);
      end loop;

      num := random(gen);
      negative_index := integer(num);
      Put_Line("Negative element (-1) has been puted into ("&negative_index'img&") index");

      arr(negative_index) := -1;
   end Init_Arr;


   protected thread_manager is
      procedure collect_min_element(min_element, index_of_min_element: in integer);
      entry get_final_min_element(min_element, index_of_min_element: out integer);
   private
      finished_threads: integer := 0;
      inner_min_element: integer := arr(1);
      index_of_inner_min_element: integer := 1;
   end thread_manager;

   protected body thread_manager is
      procedure collect_min_element(min_element, index_of_min_element: in integer) is
      begin
         finished_threads := finished_threads + 1;

         if min_element < inner_min_element then
            inner_min_element := min_element;
            index_of_inner_min_element := index_of_min_element;
         end if;
      end collect_min_element;

      entry get_final_min_element(min_element, index_of_min_element: out integer) when finished_threads >= thread_count is
      begin
         min_element := inner_min_element;
         index_of_min_element := index_of_inner_min_element;
      end get_final_min_element;
   end thread_manager;


   procedure find_local_min(start_index, end_index: in integer; min_element, index: out integer) is
      local_min_element: integer := arr(start_index);
      index_of_min_element: integer := start_index;
   begin

      for i in start_index..end_index loop
         if arr(i) < local_min_element then
            local_min_element := arr(i);
            index_of_min_element := i;
         end if;
      end loop;

      min_element := local_min_element;
      index := index_of_min_element;
   end find_local_min;


   task type find_local_min_element_thread is
      entry start(start_index, end_index: in integer);
   end find_local_min_element_thread;

   task body find_local_min_element_thread is
      local_min_element: integer;
      index_of_local_min_element: integer;
      start_index, end_index: integer;
   begin
      accept start(start_index, end_index: in integer) do
         find_local_min_element_thread.start_index := start_index;
         find_local_min_element_thread.end_index := end_index;
      end start;

      Put_Line("Thread have started successfully, start index: "&start_index'img&" end index: "&end_index'img);

      find_local_min(start_index, end_index, local_min_element, index_of_local_min_element);
      thread_manager.collect_min_element(local_min_element, index_of_local_min_element);
   end find_local_min_element_thread;


   procedure find_min_element_multithread(out_min_element, out_index_of_min_element: out integer) is
      threads: array(0..thread_count - 1) of find_local_min_element_thread;
      elements_amount_for_one_thread: integer;
   begin
      elements_amount_for_one_thread := array_length / thread_count;
      for i in 0..(thread_count - 2) loop
         threads(i).start((i * elements_amount_for_one_thread), ((i + 1) * elements_amount_for_one_thread));
      end loop;
      threads(thread_count - 1).start((thread_count - 1) * elements_amount_for_one_thread, array_length);

      thread_manager.get_final_min_element(out_min_element, out_index_of_min_element);
   end find_min_element_multithread;

   layout_min_element: integer;
   layout_index_of_min_element: integer;

begin
   Init_Arr;
   Put_Line("----");
   find_min_element_multithread(layout_min_element, layout_index_of_min_element);
   Put_Line("----");
   Put_Line("Threads found min element: "&layout_min_element'img&", index: "&layout_index_of_min_element'img&";");
   Put_Line("----");
end main;
