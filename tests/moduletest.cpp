#include <iostream>
#include <qi/anymodule.hpp>
#include "api.hpp"

qiLogCategory("moduletest");

class MODULE_TEST_API Mouse
{
  public:
    int squeak();

    qi::Property<int> size;
};

QI_REGISTER_OBJECT(Mouse, squeak, size);

int Mouse::squeak()
{
  qiLogInfo() << "squeak";
  return 18;
}

class MODULE_TEST_API Cat
{
  public:
    Cat();
    Cat(const std::string& s);

    std::string meow(int volume);
    bool eat(const Mouse& m);

    qi::Property<float> hunger;
    qi::Property<float> boredom;
    qi::Property<float> cuteness;
};

QI_REGISTER_OBJECT(Cat, meow, hunger, boredom, cuteness);

Cat::Cat()
{
  qiLogInfo() << "Cat constructor";
}

Cat::Cat(const std::string& s)
{
  qiLogInfo() << "Cat string constructor: " << s;
}

std::string Cat::meow(int volume)
{
  qiLogInfo() << "meow: " << volume;
  return "meow";
}

bool Cat::eat(const Mouse& m)
{
  qiLogInfo() << "eating mouse";
  return true;
}

int lol()
{
  return 3;
}

void registerObjs(qi::ModuleBuilder* mb)
{
  mb->advertiseFactory<Mouse>("Mouse");
  mb->advertiseFactory<Cat>("Cat");
  mb->advertiseFactory<Cat, std::string>("Cat");
  mb->advertiseMethod("lol", lol);
}

QI_REGISTER_MODULE("moduletest", &registerObjs);