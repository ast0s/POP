with Ada.Text_IO, GNAT.Semaphores;
use Ada.Text_IO, GNAT.Semaphores;
with Ada.Containers.Indefinite_Doubly_Linked_Lists;
use Ada.Containers;

procedure Main is

   package String_Lists is new Indefinite_Doubly_Linked_Lists (String);
   use String_Lists;

   StorageSize : Integer := 4;
   WorkTarget : Integer := 16;
   ProducersCount : Integer := 2;
   ConsumersCount : Integer := 2;

   Storage : List;
   Access_Storage : Counting_Semaphore (1, Default_Ceiling);
   Full_Storage   : Counting_Semaphore (StorageSize, Default_Ceiling);
   Empty_Storage  : Counting_Semaphore (0, Default_Ceiling);

   ItemsDone : Integer := 0;
   Access_ItemsDone : Counting_Semaphore (1, Default_Ceiling);
   ItemsConsumed : Integer := 0;
   Access_ItemsConsumed : Counting_Semaphore (1, Default_Ceiling);

   task type ProducerTask;
   task body ProducerTask is
   begin

      while ItemsDone < WorkTarget loop
         Access_ItemsDone.Seize;
         if ItemsDone < WorkTarget then
            Full_Storage.Seize;
            delay 0.25;
            Access_Storage.Seize;

            Storage.Append ("item " & ItemsDone'Img);
            Put_Line ("Producer add item " & ItemsDone'Img);
            ItemsDone := ItemsDone + 1;

            Access_Storage.Release;
            Empty_Storage.Release;
         end if;
         Access_ItemsDone.Release;
      end loop;

   end ProducerTask;


   task type ConsumerTask;
   task body ConsumerTask is
   begin

      while ItemsConsumed < WorkTarget loop
         Access_ItemsConsumed.Seize;
         if ItemsConsumed < WorkTarget then
            Empty_Storage.Seize;
            delay 0.25;
            Access_Storage.Seize;

            declare
               item : String := First_Element (Storage);
            begin
               Put_Line ("Consumer took " & item);
            end;
            Storage.Delete_First;
            ItemsConsumed := ItemsConsumed + 1;

            Access_Storage.Release;
            Full_Storage.Release;
         end if;
         Access_ItemsConsumed.Release;
      end loop;

   end ConsumerTask;

   Consumers : Array(1..ConsumersCount) of ConsumerTask;
   Producers : Array(1..ProducersCount) of ProducerTask;

begin
   null;
end Main;
