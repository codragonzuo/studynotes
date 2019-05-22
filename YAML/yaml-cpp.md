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

```cpp
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





known conversion for argument 2 from ‘const Employee’ to ‘Department&’ ta.cpp:28:16: note: YAML::Emitter& operator<<(YAML::Emitter&, Employee&) ta.cpp:28:16: note: no known conversion for argument 2 from ‘const Employee’ to ‘Employee&’

Here is the complete source file:

#include <iostream>
#include <fstream>
#include "yaml-cpp/yaml.h"
#include <cassert>
#include <vector>
#include <string>

struct Employee
{
        std::string name;
        std::string surname;
        int age;
        std::string getName(){return name;}
        std::string getSurname(){return surname;}
        int getAge(){return age;}
};

struct Department
{
    std::string name;
    int headCount;
    std::vector<Employee>  staff;
    std::string getName(){return name;}
    int getHeadCount(){return headCount;}
    std::vector<Employee> & getStaff(){return staff;}
};

YAML::Emitter& operator << (YAML::Emitter& out, Employee& e) {
        out << YAML::BeginMap;
        out << YAML::Key <<"name"<<YAML::Value <<e.getName();
        out << YAML::Key <<"surname"<<YAML::Value <<e.getSurname();
        out << YAML::Key <<"age"<<YAML::Value <<e.getAge();
        out << YAML::EndMap;
        return out;
}

YAML::Emitter& operator << (YAML::Emitter& out, Department& d) {
        out << YAML::BeginMap;
        out << YAML::Key <<"name"<<YAML::Value <<d.getName();
        out << YAML::Key <<"headCount"<<YAML::Value <<d.getHeadCount();
        out << YAML::Key <<"Employees"<<YAML::Value <<d.getStaff();
        out << YAML::EndMap;
        return out;
}


int main()
{
    Employee k;
    Department d;

    d.name="Twidlers";
    d.headCount=5;

    k.name="harry";
    k.surname="person";
    k.age=70;
    d.staff.push_back(k);

    k.name="joe";
    k.surname="person";
    k.age=30;
    d.staff.push_back(k);

    k.name="john";
    k.surname="doe";
    k.age=50;
    d.staff.push_back(k);

    std::ofstream ofstr("output.yaml");
    YAML::Emitter out;
    out<<d;
    ofstr<<out.c_str();
}
```



The overloads provided for vector take a const std::vector<T>&, so you'll have to sprinkle some extra consts throughout:

YAML::Emitter& operator << (YAML::Emitter& out, const Employee& e)
...

YAML::Emitter& operator << (YAML::Emitter& out, const Department& d)

and then put them on your member functions, e.g.:

const std::vector<Employee>& getStaff() const { return staff; }

(In general, you should make your getters const by default, and if you need to mutate state, add setters instead of non-const getters.)
