#include <iostream>
#include <iomanip>
#include <string>

using namespace std;

int main(){

    string name;
	double salaryIn, salaryOut, sales;
    
	cin >> name;
	cin >> salaryIn;
	cin >> sales;

	salaryOut = (sales * 0.15) + salaryIn;

	cout << "TOTAL = R$ " << fixed << setprecision(2) << salaryOut << "\n";

	return 0;

}