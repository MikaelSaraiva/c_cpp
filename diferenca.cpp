#include <iostream>

using namespace std;

int main(){

	int A, B, C, D;

	cin >> A;
	cin >> B;
	cin >> C;
	cin >> D;

	int ab = A * B;
	int cd = C * D;
	int diferenca = ab - cd;	

	cout << "DIFERENCA = " << diferenca << "\n";
	return 0;

}