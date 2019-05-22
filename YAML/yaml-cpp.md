# yaml-cpp example

```yaml
# robot.yaml
- name: Ogre
  position: [0, 5, 0]
  powers:
    - name: Club
      damage: 10
    - name: Fist
      damage: 8
- name: Dragon
  position: [1, 0, 10]
  powers:
    - name: Fire Breath
      damage: 25
    - name: Claws
      damage: 15
- name: Wizard
  position: [5, -3, 0]
  powers:
    - name: Acid Rain
      damage: 50
    - name: Staff
      damage: 3
```

```
#include "yaml-cpp/yaml.h"
#include <iostream>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>


using namespace std;


struct Vec3 {
   float x, y, z;
};

struct Power {
   std::string name;
   int damage;
};

struct Monster {
   std::string name;
   Vec3 position;
   std::vector <Power> powers;
};

void operator >> (const YAML::Node& node, Power& power);
void operator >> (const YAML::Node& node, Monster& monster);
void operator >> (const YAML::Node& node, Vec3& v);


template<typename T>
void operator >> (const YAML::Node& node, T& i)
{
    i = node.as<T>();
}


void operator >> (const YAML::Node& node, Vec3& v) {
   node[0] >> v.x;
   node[1] >> v.y;
   node[2] >> v.z;
}

void operator >> (const YAML::Node& node, Power& power) {
   node["name"] >> power.name;
   node["damage"] >> power.damage;
}

void operator >> (const YAML::Node& node, Monster& monster) {
   node["name"] >> monster.name;
   node["position"] >> monster.position;
   const YAML::Node& powers = node["powers"];
   for(unsigned i=0;i<powers.size();i++) {
      Power power;
      powers[i] >> power;
      monster.powers.push_back(power);
   }
}



int main()
{
    cout << "Hello world!" << endl;

    YAML::Node doc = YAML::LoadFile("robot.yaml");

    cout << doc.size() << endl;
    for(unsigned i=0;i<doc.size();i++) {
        Monster monster;
        doc[i] >> monster;
        std::cout << monster.name << "\n";
        std::cout << monster.position.x << "," << monster.position.y << "," << monster.position.z <<  "\n";
        std::cout << monster.powers[0].damage << "\n";
        std::cout << monster.powers[0].name << "\n";
        std::cout << monster.powers[1].damage << "\n";
        std::cout << monster.powers[1].name << "\n";
    }
    return 0;
}

```
