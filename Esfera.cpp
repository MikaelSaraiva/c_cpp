
#include <iostream>
#include <iomanip>

using namespace std;

int main(){

    double volume;
    double raio;
    double pi = 3.14159;

    cin >> raio;

    volume = (4.0/3) * pi * (raio * raio * raio);

    cout << "VOLUME = " << fixed << setprecision(3) << volume << "\n";

    return 0;
}