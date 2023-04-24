using System;
using System.Threading;

namespace Lab1POP
{
    class Program
    {
        public static void Main(String[] args)
        {
            try {
                Console.WriteLine("Enter the desired amount of threads: ");
                int numThreads = int.Parse(Console.ReadLine());

                Console.WriteLine("Enter the step to calculate: ");
                int step = int.Parse(Console.ReadLine());

                Thread[] calculatorThreads = new Thread[numThreads];
                Thread[] delayTime = new Thread[numThreads];

                for (int i = 0; i < numThreads; i++)
                {
                    Console.WriteLine("Enter the time (sec) of delay for " + (i + 1) + " thread: ");
                    int timeDelay = int.Parse(Console.ReadLine());

                    Stopper threadStopper = new Stopper(timeDelay);
                    Calculator calculator = new Calculator(i + 1, threadStopper, step);
                    delayTime[i] = new Thread(() => threadStopper.setDelay());
                    calculatorThreads[i] = new Thread(() => calculator.Result());
                }

                for (int i = 0; i < numThreads; i++)
                {
                    calculatorThreads[i].Start();
                    delayTime[i].Start();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
