#include <iostream>
#include <cstdlib>
using namespace std;

int n;
string x;
int s = 10;

int small(string x)
{

    for (int i = 0; i < x.size(); i++)
    {

        char temp = x[i];
        int temp2 = temp - '0';

        if (temp2 < s)
        {
            s = temp2;
        }
        // cout<<s;
    }
    return s;
}

int main()
{

    cin >> n;

    for (int i = 0; i < n; i++)
    {

        cin >> x;
        s = small(x);
        cout << s << endl;
        s = 100;
    }

    return 0;
}