#include <iostream>
#include <iomanip>

using namespace std;

int main(){

	double A, B, C;
	cin >> A >> B >> C;
	cout << "MEDIA = " << fixed << setprecision(1) << ((A * 0.2) + (B * 0.3) + (C * 0.5)) << "\n";
	return 0;

}