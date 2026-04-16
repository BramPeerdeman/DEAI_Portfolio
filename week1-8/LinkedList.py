from abc import ABC, abstractmethod

class LinkedList(ABC):
    
    @abstractmethod
    def size(self):
        pass
      
    @abstractmethod
    def to_string(self):
        pass
    
    @abstractmethod
    def addFirst(self,value):
        pass
    
    @abstractmethod
    def remove(self, value):
        pass
    
    @abstractmethod
    def smallest(self):
        pass
    
    @abstractmethod
    def sortSimple(self):
        pass
      
    @abstractmethod
    def uniq(self):
        pass
    
class LinkedListEmpty(LinkedList):
    def size(self):
        return 0
    def to_string(self):
        return ""
    def addFirst(self,value):
        return LinkedListPopulated(value, self)
    def remove(self, value):
        return self
    def smallest(self):
        return None
    def sortSimple(self):
        return self
    def uniq(self):
        return 0
    
class LinkedListPopulated(LinkedList):
    def __init__(self, value, tail):
        self.value = value
        self.tail = tail

    def size(self):
        return 1 + self.tail.size()
      
    def to_string(self):
        return str(self.value) + " " + self.tail.to_string()
    
    def addFirst(self, value):
        return LinkedListPopulated(value, self)
    
    def remove(self, value):
        if self.value == value:
            return self.tail
        else:
            return LinkedListPopulated(self.value, self.tail.remove(value))
        
    def smallest(self):
            kleinste_van_de_rest = self.tail.smallest()
            if kleinste_van_de_rest is None:
                return self.value
            if self.value < kleinste_van_de_rest:
                return self.value
            else:
                return kleinste_van_de_rest
            
    def sortSimple(self):
        kleinste = self.smallest()
        rest_lijst = self.remove(kleinste)
        gesorteerde_rest = rest_lijst.sortSimple()
        return gesorteerde_rest.addFirst(kleinste)
      
    def uniq(self):
        if isinstance(self.tail, LinkedListEmpty):
            return 1
        if self.value == self.tail.value:
            return self.tail.uniq()
        else:
            return 1 + self.tail.uniq()