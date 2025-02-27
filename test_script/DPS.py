damage = 150
rate_of_fire = 0.5

attacks_per_second = 1 / rate_of_fire

duration = 10 
enemy_armour = 25


post_mitigation_damage = damage / (1 + (enemy_armour / 100))
dps = post_mitigation_damage * attacks_per_second


print(dps * duration)