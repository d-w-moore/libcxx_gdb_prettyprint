#include <iostream>
#include <vector>

int main()
{
  std::string      mystr { "hello" };
  std::vector<int> myvec { 3,4 };

  std::cout << mystr << std::endl;

  for (auto &i : myvec) {
    std::cout << i << std::endl;
  }

  return 0;
}

