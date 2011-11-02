package org.sbgn;

import java.io.File;
import java.util.List;

import org.sbgn.schematron.Issue;
import org.sbgn.schematron.SchematronValidator;

/**
 * Main provides a set of utilities that can be accessed from the command line.
 */
public class Main {

	public static void main(String[] args) 
	{
		Main main = new Main();
		try
		{
			main.run(args);
		}
		catch (IllegalArgumentException e)
		{
			System.out.println ("ERROR: " + e.getMessage());
			main.printUsage();
			System.exit(1);
		}
	}
	
	/**
	 * Print information on how to use this program to the screen.
	 */
	private void printUsage() 
	{
		System.out.println ("Usage:\n" +
				"\n" +
				"sbgnutil -version\n" +
				"    print versioh information.\n" +
				"\n" +
				"sbgnutil -help\n" +
				"    print this help.\n" +
				"\n" +
				"sbgnutil -validate <file>:\n" +
				"    Validate a single SBGN file.\n" +
				"    First, low-level validation is performed on the XML syntax.\n" +
				"    If the syntax is correct, the validator then proceeds with\n" +
				"    high-level semantic validation.\n" +
				"    Any validation issues found are printed as regular text.\n" +
				"    Returns error code 2 if low-level validation failed,\n" +
				"    or error code 3 if high-level validation failed.\n" +
				"\n" +
				"sbgnutil -upgrade <infile> <outfile>\n" +
				"    Convert an sbgn file from Milestone 1 to Milestone 2.\n"
			);
		
	}

	/**
	 * Main entry point. Delegates execution to different methods based on the arguments passed.
	 * @throws IllegalArgumentException if any of the command line arguments is invalid.
	 */
	private void run(String[] args) {
		if (args.length == 0)
		{
			throw new IllegalArgumentException("Expected at least one argument");
		}
		String cmd = args[0];
		if ("-version".equals(cmd))
		{
			if (args.length != 1) throw new IllegalArgumentException("Did not expect any arguments after -version");
			System.out.println ("LibSBGN Milestone 2");
			return;
		}
		else if ("-help".equals(cmd))
		{
			if (args.length != 1) throw new IllegalArgumentException("Did not expect any arguments after -help");
			printUsage();
			return;
		}
		else if ("-validate".equals(cmd))
		{
			validate(args);
		}
		else if ("-upgrade".equals(cmd))
		{
			upgrade(args);
		}
		else
		{
			throw new IllegalArgumentException("Unrecognized command: " + cmd);
		}
	}

	/**
	 * Handle the -upgrade function.
	 */
	private void upgrade(String[] args) 
	{
		if (args.length != 3) throw new IllegalArgumentException("You have to specify an input file and an output file.");
		File fin = new File (args[1]);
		File fout = new File (args[2]);
		try
		{
			ConvertMilestone1to2.convert (fin, fout);
		}
		catch (Exception e)
		{
			System.err.println ("Conversion failed because of " + e.getClass().getName());
			System.err.println (e.getMessage());
		}
	}

	/**
	 * Handle the -validate function.
	 */
	private void validate(String[] args) 
	{
		int pos = 1;
		// secret argument: add -svrldump to see svrl
		if (args.length > pos && args[pos].equals ("-svrldump")) 
		{
			pos++;
			SchematronValidator.setSvrlDump(true);
		}
		
		if (args.length == pos) throw new IllegalArgumentException("Missing argument: input file");
		File fin = new File (args[pos]);
		try
		{
			if (!SbgnUtil.isValid(fin))
			{
				System.out.println ("Low-level validation failed");
				System.exit(2);
			}
			System.out.println ("Low-level validation passed");
			List<Issue> issues = SchematronValidator.validate(fin);
			System.out.println (issues.size() + " high-level validation issues");
			for (Issue i : issues)
			{
				System.out.println (i.getSeverity() + "\t" + i.getAboutId() + "\t" + i.getRuleId() + "\t" + i.getRuleDescription());
			}
			if (issues.size() > 0)
			{
				System.exit(3);
			}
			return;
		}
		catch (Exception e)
		{
			System.err.println ("Conversion failed because of " + e.getClass().getName());
			System.err.println (e.getMessage());
		}
	}

}
