from queue import PriorityQueue

class PriorityStack():
    priority_queue = PriorityQueue()
    # This variable is being used to force the PriorityQueue to be a priority stack
    priority = 0

    def put(self, data, priority=0):
        self.priority_queue.put((priority, self.priority, data))
        self.priority -= 1

    def get(self):
        _, _, item = self.priority_queue.get()
        return item

    def empty(self):
        return self.priority_queue.empty()