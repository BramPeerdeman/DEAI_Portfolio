import csv
import sys

sys.setrecursionlimit(20000000)

from LinkedList import LinkedListEmpty

kentekens = LinkedListEmpty()

# Inlezen van het bestand
with open(sys.argv[1]) as f:
    reader = csv.reader(f, delimiter=',')
    for row in reader:
        kentekens = kentekens.addFirst(row[0])

# --- DIT STUKJE HEBBEN WE TOEGEVOEGD ---
print("Bestand succesvol ingelezen! Nu bezig met sorteren (dit kan even duren)...")

# Sorteer de lijst
gesorteerde_kentekens = kentekens.sortSimple()
aantal_uniek = gesorteerde_kentekens.uniq()

# Print het resultaat
print(f"Het totale aantal ingelezen kentekens was: {kentekens.size()}")
print(f"Het aantal UNIEKE kentekens in dit bestand is: {aantal_uniek}")