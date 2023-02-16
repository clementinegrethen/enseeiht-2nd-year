package cgrethen.enseeiht.webbrowser;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import org.w3c.dom.Text;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "Browser Activity";
    Button myButton;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.d( TAG, "OnCreate() called!" );
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        myButton=(Button) findViewById(R.id.button);
        EditText mytext = (EditText) findViewById(R.id.editTextTextMultiLine);

        myButton.setOnClickListener(
                new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i= new Intent();
                i.setAction(Intent.ACTION_VIEW);
                i.setData(Uri.parse(mytext.getText().toString()));
                startActivity(i);}
        });


    }
}