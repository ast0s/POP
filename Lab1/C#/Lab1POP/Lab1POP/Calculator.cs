using System;

namespace Lab1POP
{
    class Calculator
    {
        private int _id;
        private int _step;
        private long _count;
        private Stopper _stopper;

        public Calculator(int id, Stopper stopper, int step)
        {
            _id = id;
            _stopper = stopper;
            _step = step;
        }

        private long Sum()
        {
            long sum = 0;
            while (!_stopper.canStop)
            {
                sum += _step;
            }
            _count = sum / _step;
            return sum;
        }

        public void Result()
        {
            Console.WriteLine($"Thread number: {_id} - result: {Sum()} (counter - {_count})");
        }
    }
}
