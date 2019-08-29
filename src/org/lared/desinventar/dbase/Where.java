package org.lared.desinventar.dbase;

import java.sql.SQLException;

/**
* Class to hold WHERE clause information.
* There is one Where  for each conjunction in the where clause.
*/

// Where is special. They have a field on the left side but might have a literal or field on the right.
// There is also an operator,  And there is a conjuctive between these field.comparitive operator..comparitive
// members.  This would be an array of field, value, value type, operator and conjunctive.  The operator
// can have the moderator NOT.
// The conjunctive is empty for the last element.
/**
* Inner class covering data required in a where clause.
*/
public class Where
{
	static final int COMPARITOR_EQUAL = 0;	// =
	static final int COMPARITOR_NOTEQUAL = 1;	// <>
	static final int COMPARITOR_GT = 2; // >
	static final int COMPARITOR_LT = 3;	// >
	static final int COMPARITOR_LTEQ = 4;	// <=
	static final int COMPARITOR_GTEQ = 5;	// >=
	static final int COMPARITOR_UNKNOWN = 6;	// Unknown comparitor.

	public final static int CONJ_AND = 0;	// AND
	public final static int CONJ_OR = 1;		// OR
	public final static int CONJ_NONE = 2;	// No further conjunctive.

	private final static int TYPE_INT = 0;	// Integer type.
	private final static int TYPE_STR = 1;	// String type.
	private final static int TYPE_DOUB = 2;	// Double type.

	public String field;	// Left hand field name.
	public FieldValue fValue;	// Right hand value (identifier or literal).
	public int valueType;	// Value is a field name or literal.
	public boolean notOperator;	// If the comparison is prefaced by NOT this is true.
	public int conjunction;	// AND or OR or NONE (for the first).
	int operator;	// Comparison operator.

	/**
	* Default constructor.
	*/
	public Where()
	{
		notOperator = false;	// Assume there's no NOT in the statement.
		conjunction = CONJ_NONE;	// Assume no conjunction - this is the first one..
	}

	/**
	* Comparitor method for determining acceptance of a result.
	*
	* @param dbValue Database value.  This should be the class representation of the primitive or a string.
	*
	* @return true if there's a match, false otherwise.
	*/
	public boolean comparitor(Object dbValue) throws SQLException
	{
		boolean comp;	// Comparison result.

		// A caparitor compares the value of the db object against the field name and value of this
		// where object.  If the field doesn't match, return false.
		// Othewise perform the comparison and return the result.
		// Currently we don't support field types since they require a call to the database to lookup the field value in
		// another table (to make any sense).
		// Conjunctions are handled elsewhere.

//System.out.println("comparitor: Starting - " + dbValue + " & " + fValue.value);
//System.out.println("Where.comparitor: " + operator);
		switch (operator)
		{
			case COMPARITOR_EQUAL:
//System.out.println("comparitor: Comparing equality " + dbValue + " & " + fValue.value);

				if (dbValue.equals(fValue.value))
					if (notOperator)
						return false;
					else
						return true;
				return false;

			case COMPARITOR_NOTEQUAL:
//System.out.println("Comparing not equal");
				if (dbValue.equals(fValue.value))
					if (notOperator)
						return true;
					else
						return false;
				return false;

			case COMPARITOR_GT:
				comp = compare(dbValue) > 0;
				return (notOperator) ? !comp : comp;

			case COMPARITOR_LT:
				comp = compare(dbValue) < 0;
				return (notOperator) ? !comp : comp;

			case COMPARITOR_LTEQ:
				comp = compare(dbValue) <= 0;
				return (notOperator) ? !comp : comp;

			case COMPARITOR_GTEQ:
				comp = compare(dbValue) >= 0;
				return (notOperator) ? !comp : comp;

			default:
				throw new SQLException("Unknown comparison of type " + operator + " in statement.");
		}
	}

	/**
	* Compare the database object against the FieldValue object/
	*
	* @param dbValue Database value.
	*
	* @return An int with a negative value, 0, or positive value based on the compariston.
	*/
	private int compare(Object dbValue) throws SQLException
	{
		// Should handle dates someday.

		int comp;

//System.out.println("Where.compare: type is " + typeOf(dbValue));
		switch (typeOf(dbValue))
		{
			case TYPE_INT:
				comp = ((Integer)dbValue).compareTo((Integer)fValue.value);	// - if  fv.value less than dbValue
				break;
			case TYPE_STR:
				comp = ((String)dbValue).compareTo((String)fValue.value);	// - if  fv.value less than dbValue
//System.out.println("Where.compare: comparing " + (String)fValue.value + " to " + dbValue + " = " + comp);
				break;
			case TYPE_DOUB:
				comp = ((Double)dbValue).compareTo((Double)fValue.value);	// - if  fv.value less than dbValue
				break;

			default:
				throw new SQLException("Unknown type of comparison: " + typeOf(dbValue) + ".");
		}

		return comp;
	}
	/**
	* Determine the type of object passed.
	* @return type as an int.
	* @throws SQLException if it's not an expected type.
	*/
	int typeOf(Object o) throws SQLException
	{
		if (o instanceof Double)
			return TYPE_DOUB;

		else if (o instanceof String)
			return TYPE_STR;

		else if (o instanceof Integer)
			return TYPE_INT;

		else
			throw new SQLException("Uknown type passed: " + o.getClass().getName());
	}

	/**
	* String representation of this object.
	*
	* @return string.
	*/
	public String toString()
	{
		StringBuffer sb = new StringBuffer("Where: ");

		if (notOperator)
			sb.append("NOT ");

		sb.append("CONJ=");
		if (conjunction != CONJ_NONE)
			sb.append( (conjunction == CONJ_AND) ? "AND" : "OR");
		else
			sb.append("NONE");
		sb.append(", ");

		sb.append(field);

		switch (operator)
		{
			case COMPARITOR_EQUAL:
				sb.append(" = ");
				break;
			case COMPARITOR_NOTEQUAL:
				sb.append(" <> ");
				break;
			case COMPARITOR_GT:
				sb.append(" > ");
				break;
			case COMPARITOR_LT:
				sb.append(" < ");
				break;
			case COMPARITOR_LTEQ:
				sb.append(" <= ");
				break;
			case COMPARITOR_GTEQ:
				sb.append(" >= ");
				break;
			default:
				sb.append("Unknown (").append(operator).append(')');
				break;
		}

		sb.append(fValue);

		return sb.toString();
	}

}