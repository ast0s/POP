using System;
using System.Threading;

namespace Lab1POP
{
    public class Stopper
    {
        public volatile bool canStop = false;
        private int delayTime;

        public Stopper(int delayTime)
        {
            this.delayTime = delayTime;
        }

        public void setDelay()
        {
            try
            {
                Thread.Sleep(delayTime * 1000);
                canStop = true;
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
