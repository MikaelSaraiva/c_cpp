#include <iostream>
#include <iomanip>

using namespace std;

int main(){

	double A, B;
	cin >> A >> B;
	cout << "MEDIA = "<< fixed << setprecision(5) << ((A * 0.35) + (B * 0.75))/1.1 << "\n";

	return 0;

}