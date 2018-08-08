#include <iostream>
#include <iomanip>

using namespace std;

int main(){

	int number, hours;
	double salary, cost;

	cin >> number;
	cin >> hours;
	cin >> cost;
	
	salary = hours * cost;

	cout << "NUMBER = " << number << "\n";
	cout << "SALARY = U$ " << fixed << setprecision(2) << salary << "\n";

	return 0;

}